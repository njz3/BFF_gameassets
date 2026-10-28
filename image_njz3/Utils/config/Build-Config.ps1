# Fabrique les fichiers de configuration des emulateurs a partir d'UN template
# par fichier et de tables de valeurs, au lieu d'une copie par combinaison.
#
#   .\Build-Config.ps1 -Res _1920x1080          changer de moniteur
#   .\Build-Config.ps1 -Cabine _link_cab2       changer l'identite de cabine
#   .\Build-Config.ps1 -EnregistrerModele       figer les reglages courants
#   .\Build-Config.ps1 -Res _320x240 -WhatIf    voir sans rien ecrire
#
# DEUX AXES QUI NE SE MELANGENT PAS
#
# La resolution est une propriete du MONITEUR, l'identite de cabine une
# propriete de la MACHINE. Choisir solo ou link reste ce que fait le joueur
# dans AttractPlus en prenant la liste Single ou la liste Multi.
#
# Et surtout, les deux axes ne portent pas la meme chose :
#
#   - la resolution ne produit que de la CONFIGURATION. On la change quand on
#     veut, aussi souvent qu'on veut : passer d'un LCD Full HD a un CRT en
#     super-resolution ne doit rien casser ni rien reinitialiser ;
#   - la cabine, elle, touche aussi a de l'ETAT : les NVRAM, qui gardent les
#     reglages du menu de service ET les meilleurs temps.
#
# D'ou la regle, qui est tout l'interet de ce script :
#
#   UNE CIBLE DE TYPE FOLDER N'EST RECOPIEE QUE SI LA CABINE A VRAIMENT
#   CHANGE. Jamais sur un changement de resolution.
#
# Le dossier vivant porte un temoin, _cabine.txt, qui dit pour quelle cabine
# il a ete pose. Tant qu'il concorde, on n'y touche pas.
#
# Pourquoi ce n'est pas negociable : le mode et le numero de cabine ne sont
# PAS patchables dans une NVRAM Supermodel. Les jeux Model 3 verifient une
# somme de controle sur leur enregistrement de reglages ; changer un seul
# octet, meme un zero de bourrage, fait retomber le jeu aux valeurs d'usine.
# La seule voie sure est donc le dossier modele capture depuis le menu de
# service - et il faut d'autant moins l'ecraser par accident.
#
# PREPARER UNE IMAGE A CLONER
#
#   1. poser la cabine voulue :      -Cabine _link_cab1
#   2. lancer les jeux, regler ce qu'on veut dans leur menu de service
#   3. figer ces reglages :          -EnregistrerModele
#
# L'etape 3 recopie le dossier vivant VERS le modele de la cabine courante.
# C'est ce qu'il faut faire apres une mise a jour d'emulateur qui change le
# format des NVRAM : on laisse le jeu migrer, puis on enregistre.
#
# ORDRE DES VALEURS, la plus precise l'emportant :
#   resolutions.csv  <  cabinets.csv  <  games.csv
#
# Un mot-cle {{AINSI}} reste dans la sortie = erreur : aucune table ne le
# donne. Mieux vaut echouer que deposer une configuration a trous.
param(
    # La resolution a appliquer. Omise, on garde celle deja en place.
    [string]$Res,
    # Change l'identite de cabine de CETTE machine : reecrit set_cab_id.bat,
    # puis repose tout, NVRAM comprises. Operation rare, en general au
    # moment de cloner le disque.
    [string]$Cabine,
    # Prepare l'image d'une AUTRE machine sans toucher a set_cab_id.bat.
    [string]$PourCabine,
    # Recopie le dossier vivant VERS le modele de la cabine courante, pour
    # figer des reglages avant de cloner.
    [switch]$EnregistrerModele,
    # Repose les NVRAM meme si la cabine n'a pas change. A n'utiliser que
    # pour repartir des reglages d'origine : les meilleurs temps sont perdus.
    [switch]$ForcerNvram,
    # N'ecrit rien : dit la resolution et la cabine en place, et relit dans
    # les NVRAM posees ce qu'elles disent vraiment du mode et de l'ID.
    [switch]$Etat,
    [string]$Rom,
    [string]$Racine = 'C:\Racecab',
    [switch]$WhatIf
)
$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$TEMOIN = '_cabine.txt'

# Les commentaires sont retires AVANT la conversion : sinon la premiere ligne
# du fichier, commentaire compris, servirait d'en-tete de colonnes.
function LireCsv([string]$chemin) {
    if (-not (Test-Path -LiteralPath $chemin)) { throw "table absente : $chemin" }
    $l = @(Get-Content -LiteralPath $chemin | Where-Object { $_.Trim() -and -not $_.TrimStart().StartsWith('#') })
    if ($l.Count -lt 2) { return @() }
    $l | ConvertFrom-Csv -Delimiter ';'
}
function Lire($nom) { LireCsv (Join-Path $here "valeurs\$nom") }

function Ajouter($table, $ligne, $saufColonne) {
    foreach ($p in $ligne.PSObject.Properties) {
        if ($p.Name -eq $saufColonne) { continue }
        if ($null -eq $p.Value) { $table[$p.Name] = '' } else { $table[$p.Name] = $p.Value }
    }
}

$SetCabId = Join-Path $Racine 'Utils\set_cab_id.bat'

function LireCabId {
    if (-not (Test-Path -LiteralPath $SetCabId)) { throw "set_cab_id.bat introuvable : $SetCabId" }
    $m = Select-String -LiteralPath $SetCabId -Pattern '(?i)^\s*set\s+CAB_ID\s*=\s*(\S+)' | Select-Object -First 1
    if (-not $m) { throw "CAB_ID absent de $SetCabId" }
    $m.Matches[0].Groups[1].Value
}

function EcrireCabId([string]$valeur) {
    # Edition en place : on ne touche ni aux fins de ligne ni aux commentaires.
    $t = [IO.File]::ReadAllText($SetCabId)
    $neuf = [regex]::Replace($t, '(?m)^(\s*set\s+CAB_ID\s*=\s*)\S+[^\r\n]*', "`${1}$valeur")
    if ($neuf -eq $t) { throw "set CAB_ID introuvable dans $SetCabId" }
    if (-not $WhatIf) { [IO.File]::WriteAllText($SetCabId, $neuf) }
}

# --- la resolution en place, quand on ne la precise pas --------------------
# SetVideoCommon.bat laisse un temoin Configured_for<RES>.txt a la racine ;
# on le reprend, pour que les deux mecanismes parlent le meme langage.
function LireResEnPlace {
    $t = Get-ChildItem -LiteralPath $Racine -Filter 'Configured_for*.txt' -ErrorAction SilentlyContinue |
         Select-Object -First 1
    if (-not $t) { return $null }
    if ($t.BaseName -match '^Configured_for(.+)$') { return $Matches[1] }
    $null
}

# --- le dossier d'ecriture des emulateurs, quand il est actif ---------------
# Utils\set_writedir.bat porte WRITEDIR_ROOT, vide quand il est inactif. Lu
# pour les cibles STALE : les copies qu'un emulateur y garde de ses reglages.
function LireWriteDir {
    $f = Join-Path $Racine 'Utils\set_writedir.bat'
    if (-not (Test-Path -LiteralPath $f)) { return '' }
    $m = Select-String -LiteralPath $f -Pattern '(?i)^\s*set\s+WRITEDIR_ROOT\s*=\s*(.*?)\s*$' | Select-Object -Last 1
    if ($m) { $m.Matches[0].Groups[1].Value } else { '' }
}

function EcrireResEnPlace([string]$res) {
    if ($WhatIf) { return }
    Get-ChildItem -LiteralPath $Racine -Filter 'Configured_for*.txt' -ErrorAction SilentlyContinue |
        Remove-Item -Force
    Set-Content -LiteralPath (Join-Path $Racine "Configured_for$res.txt") `
                -Value "Configuration done for SSD$res" -Encoding ASCII
}

# --- quelle cabine, quelle resolution -------------------------------------
if ($Cabine -and $PourCabine) { throw '-Cabine et -PourCabine s excluent' }

$cabAvant = LireCabId
if ($Cabine) {
    EcrireCabId $Cabine
    $Cab = $Cabine
} elseif ($PourCabine) {
    $Cab = $PourCabine
} else {
    $Cab = $cabAvant
}

if (-not $Res) {
    $Res = LireResEnPlace
    if (-not $Res) {
        throw 'aucune resolution en place (Configured_for*.txt absent) : precisez -Res'
    }
}

$r = Lire 'resolutions.csv' | Where-Object { $_.RES -eq $Res }
if (-not $r) { throw "resolution inconnue : $Res" }

function ValeursPour([string]$cab) {
    $v = @{}
    Ajouter $v $r 'RES'
    $c = Lire 'cabinets.csv' | Where-Object { $_.CAB -eq $cab }
    if (-not $c) { throw "cabinet inconnu : $cab" }
    Ajouter $v $c 'CAB'
    if ($Rom) {
        $j = Lire 'games.csv' | Where-Object { $_.ROM -eq $Rom }
        if ($j) { Ajouter $v $j 'ROM' }
    }
    $v
}

# --- ecrire un champ dans un profil TeknoParrot -------------------------
# Les profils sont reguliers : <FieldName>X</FieldName> suivi immediatement
# de <FieldValue>Y</FieldValue>. On remplace la valeur sans rien reformater,
# et SEULEMENT pour les champs nommes dans valeurs\teknoparrot.csv : des
# champs comme ShadowMapWidth ou SpecularWidth portent eux aussi des valeurs
# de resolution et casseraient le rendu si on les ecrasait.
function EcrireChampXml([string]$texte, [string]$champ, [string]$valeur) {
    if (-not $champ) { return $texte }
    $motif = '(<FieldName>' + [regex]::Escape($champ) + '</FieldName>\s*<FieldValue>)[^<]*(</FieldValue>)'
    [regex]::Replace($texte, $motif, { param($m) $m.Groups[1].Value + $valeur + $m.Groups[2].Value })
}

# Les deux mots-cles de NOM de fichier, qui disent de quels axes une
# VARIANT ou un FOLDER depend. Ils ne vivent que dans les chemins.
function ResoudreChemin([string]$modele, [string]$cab) {
    $modele.Replace('{{RES}}', $Res).Replace('{{CAB}}', $cab)
}

# TREE : un FOLDER range par jeu (linuxloader), recopie avec ses
# sous-dossiers. Ailleurs, un sous-dossier du modele est une remise.
function Arborescent($t) {
    $t.PSObject.Properties['TREE'] -and $t.TREE -match '(?i)^\s*(yes|oui|true|1)\s*$'
}

$cibles = LireCsv (Join-Path $here 'targets.csv')

# --- relire ce qu'une NVRAM Supermodel dit vraiment -----------------------
# Le 93C46 est un composant 16 bits que Supermodel range en mots
# little-endian : l'octet LOGIQUE i est l'octet PHYSIQUE i^1. Les offsets de
# nvram-link-offsets.csv sont logiques et relatifs au bloc, car les offsets
# de FICHIER changent d'un build de Supermodel a l'autre (sa version et le
# chemin source du bloc, de longueur variable, sont en clair dans l'en-tete).
function Bloc93C46([string]$fichier) {
    $o = [IO.File]::ReadAllBytes($fichier)
    if ($o.Length -lt 16) { return $null }
    $i = [BitConverter]::ToUInt32($o, 0)
    while ($i + 12 -le $o.Length) {
        $total = [BitConverter]::ToUInt32($o, $i)
        $ln = [BitConverter]::ToUInt32($o, $i + 4)
        $lc = [BitConverter]::ToUInt32($o, $i + 8)
        if ($total -le 12 -or $i + $total -gt $o.Length) { break }
        $nom = [Text.Encoding]::ASCII.GetString($o, $i + 12, [Math]::Max(0, $ln - 1))
        if ($nom -eq '93C46') { return $o[($i + 12 + $ln + $lc)..($i + $total - 1)] }
        $i += $total
    }
    $null
}

if ($Etat) {
    "cabine en place     : $Cab"
    "resolution en place : $Res"
    $table = $null
    $csvOff = Join-Path $here 'nvram-link-offsets.csv'
    if (Test-Path -LiteralPath $csvOff) { $table = LireCsv $csvOff }
    foreach ($t in $cibles) {
        if ($t.TYPE -ne 'FOLDER') { continue }
        $vivant = Join-Path $Racine $t.TARGET
        $pose = Join-Path $vivant $TEMOIN
        $poseCab = if (Test-Path -LiteralPath $pose) { (Get-Content -LiteralPath $pose -Raw).Trim() } else { '(aucun temoin)' }
        ''
        "$($t.TARGET) : pose pour $poseCab"
        if (-not $table) { continue }
        foreach ($f in (Get-ChildItem -LiteralPath $vivant -File -Filter '*.nv' -ErrorAction SilentlyContinue)) {
            $champs = @($table | Where-Object {
                $_.JEU -eq $f.BaseName -and $_.OFFSET -and $_.SENS -notmatch 'somme de controle' })
            if (-not $champs) { continue }
            $b = Bloc93C46 $f.FullName
            if (-not $b) { continue }
            $dit = foreach ($c in $champs) {
                $o = [Convert]::ToInt32($c.OFFSET, 16)
                '{0:X2} = {1}' -f $b[$o -bxor 1], $c.SENS
            }
            "   {0,-16} {1}" -f $f.BaseName, ($dit -join ' | ')
        }
    }
    return
}

# --- figer les reglages courants dans les modeles --------------------------
if ($EnregistrerModele) {
    "enregistrement des modeles pour la cabine $Cab"
    # Deux passes : on verifie TOUT avant d'ecrire quoi que ce soit. Sinon un
    # refus sur la deuxieme cible laisserait la premiere deja ecrasee.
    $aFaire = @()
    foreach ($t in $cibles) {
        if ($t.TYPE -ne 'FOLDER') { continue }
        $cabCible = if ($t.CAB -eq '__CAB__') { $Cab } else { $t.CAB }
        $vivant = Join-Path $Racine $t.TARGET
        if (-not (Test-Path -LiteralPath $vivant)) {
            Write-Warning "dossier vivant absent : $vivant"
            continue
        }
        # Avec un dossier d'ecriture, ce que les parties ont change est la-bas
        # (<emulateur>_<identite>\<jeu>\...), pas dans le dossier en place :
        # l'enregistrer d'ici figerait l'etat d'avant le dossier d'ecriture.
        if ($t.WRITEDIR -and (LireWriteDir)) {
            Write-Warning "$($t.TARGET) : les parties ecrivent dans $(LireWriteDir)\$(ResoudreChemin $t.WRITEDIR $cabCible), le modele est pris dans le dossier en place"
        }
        $pose = Join-Path $vivant $TEMOIN
        $poseCab = if (Test-Path -LiteralPath $pose) { (Get-Content -LiteralPath $pose -Raw).Trim() } else { '' }
        if ($poseCab -and $poseCab -ne $cabCible) {
            throw "$vivant contient la cabine $poseCab, pas $cabCible : enregistrer l ecraserait avec les reglages d une autre cabine"
        }
        $aFaire += [pscustomobject]@{
            Cible    = $t.TARGET
            Vivant   = $vivant
            Modele   = Join-Path $Racine (ResoudreChemin $t.SOURCE $cabCible)
            NomCourt = ResoudreChemin $t.SOURCE $cabCible
            # Avec ses sous-dossiers pour une cible TREE, a plat sinon, comme a
            # la pose.
            Fichiers = @(Get-ChildItem -LiteralPath $vivant -File -Recurse:(Arborescent $t) | Where-Object { $_.Name -ne $TEMOIN })
        }
    }
    foreach ($a in $aFaire) {
        if ($WhatIf) {
            "[essai] {0} -> {1}  ({2} fichier(s))" -f $a.Cible, $a.NomCourt, $a.Fichiers.Count
        } else {
            New-Item -ItemType Directory -Force -Path $a.Modele | Out-Null
            foreach ($f in $a.Fichiers) {
                $dest = Join-Path $a.Modele $f.FullName.Substring($a.Vivant.TrimEnd('\').Length + 1)
                New-Item -ItemType Directory -Force -Path (Split-Path -Parent $dest) | Out-Null
                Copy-Item -LiteralPath $f.FullName -Destination $dest -Force
            }
            "enregistre {0} fichier(s) : {1} -> {2}" -f $a.Fichiers.Count, $a.Cible, $a.NomCourt
        }
    }
    return
}

# --- les cibles ------------------------------------------------------------
$changementDeCabine = ($Cabine -and $Cabine -ne $cabAvant)
if ($changementDeCabine) { "cabine : $cabAvant -> $Cabine" }

foreach ($t in $cibles) {

    # La colonne CAB d'une cible vaut une identite fixe (_single pour un
    # dossier solo), ou __CAB__ pour "celle de cette machine".
    $cabCible = if ($t.CAB -eq '__CAB__') { $Cab } else { $t.CAB }
    $type = if ($t.TYPE) { $t.TYPE } else { 'TEMPLATE' }
    $sortie = Join-Path $Racine $t.TARGET
    $source = Join-Path $Racine (ResoudreChemin $t.SOURCE $cabCible)

    # Un emulateur peut ne pas etre installe sur cette machine : on passe,
    # sans echouer. En revanche, si son dossier existe et que sa source
    # manque, c'est une vraie incoherence et on echoue (voir plus bas).
    # Une cible XML ne designe pas un fichier mais une table de profils :
    # pas de dossier parent a verifier.
    $dossierCible = Split-Path -Parent $sortie
    if ($type -notin 'XML', 'STALE' -and -not (Test-Path -LiteralPath $dossierCible)) {
        Write-Warning "$($t.TARGET) : $dossierCible absent, emulateur non installe - cible ignoree"
        continue
    }

    # OPTIONAL : une source absente previent au lieu d'echouer. Reserve aux
    # cas ou l'absence est legitime - typiquement une resolution de mise au
    # point qui n'a pas sa variante de liste de jeux.
    $facultatif = $t.PSObject.Properties['OPTIONAL'] -and
                  $t.OPTIONAL -match '(?i)^\s*(yes|oui|true|1)\s*$'
    if ($facultatif -and -not (Test-Path -LiteralPath $source)) {
        Write-Warning "$($t.TARGET) : $(ResoudreChemin $t.SOURCE $cabCible) absent, cible facultative - laissee en l etat"
        continue
    }

    switch ($type) {

        'TEMPLATE' {
            if (-not (Test-Path -LiteralPath $source)) { throw "template absent : $source" }
            $v = ValeursPour $cabCible
            $texte = [IO.File]::ReadAllText($source, [Text.Encoding]::UTF8)
            foreach ($k in $v.Keys) { $texte = $texte.Replace("{{$k}}", [string]$v[$k]) }
            $restants = [regex]::Matches($texte, '\{\{([A-Z_0-9]+)\}\}') |
                        ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique
            if ($restants) { throw "$($t.TARGET) : mot(s)-cle(s) sans valeur : $($restants -join ', ')" }
            if ($WhatIf) {
                "[essai] {0}  (res {1}, cabine {2}) -> {3:N0} octets" -f $t.TARGET, $Res, $cabCible, $texte.Length
            } else {
                $dir = Split-Path $sortie
                if (-not (Test-Path -LiteralPath $dir)) { throw "dossier absent : $dir" }
                [IO.File]::WriteAllText($sortie, $texte, (New-Object Text.UTF8Encoding $false))
                "ecrit    {0}  (res {1}, cabine {2})" -f $t.TARGET, $Res, $cabCible
            }
        }

        'VARIANT' {
            if (-not (Test-Path -LiteralPath $source)) { throw "variante absente : $source" }
            if ($WhatIf) {
                "[essai] {0} <- {1}" -f $t.TARGET, (ResoudreChemin $t.SOURCE $cabCible)
            } else {
                Copy-Item -LiteralPath $source -Destination $sortie -Force
                "copie    {0} <- {1}" -f $t.TARGET, (Split-Path -Leaf $source)
            }
        }

        'FOLDER' {
            # De l'ETAT, pas de la configuration : on ne repose que si la
            # cabine en place differe. Un changement de resolution passe donc
            # ici sans rien toucher, et les meilleurs temps sont preserves.
            if (-not (Test-Path -LiteralPath $source)) { throw "dossier modele absent : $source" }
            $pose = Join-Path $sortie $TEMOIN
            $poseCab = if (Test-Path -LiteralPath $pose) { (Get-Content -LiteralPath $pose -Raw).Trim() } else { '' }
            # Pas de break ici : dans un switch imbrique dans une boucle, il
            # est ambigu. Un simple if/else, et la boucle continue.
            if ($poseCab -eq $cabCible -and -not $ForcerNvram) {
                "garde    {0}  (deja en {1}, rien touche)" -f $t.TARGET, $cabCible
            } else {
            $raison = if ($ForcerNvram) { 'force' } elseif ($poseCab) { "etait en $poseCab" } else { 'aucun temoin' }
            # Un dossier modele est recopie TEL QUEL : une sauvegarde laissee
            # dedans finirait dans le dossier vivant. On les laisse de cote et
            # on le dit, plutot que de les deposer en silence. Une cible TREE
            # est rangee par jeu : recopiee avec ses sous-dossiers, et videe
            # avant, pour qu'un jeu absent du modele n'y reste pas.
            $recursif = Arborescent $t
            $tous = @(Get-ChildItem -LiteralPath $source -File -Recurse:$recursif | Where-Object { $_.Name -ne $TEMOIN })
            $fichiers = @($tous | Where-Object { $_.Name -notmatch '(?i)\.(bak|old|tmp)$|\.avant-|\.capture-|~$' })
            foreach ($x in ($tous | Where-Object { $fichiers -notcontains $_ })) {
                Write-Warning "$($t.TARGET) : $($x.Name) ressemble a une sauvegarde, non recopie (rangez-le dans un sous-dossier)"
            }
            # Un .nv present dans le vivant mais absent du modele garderait
            # l'identite de l'ancienne cabine : il faut le signaler.
            if (Test-Path -LiteralPath $sortie) {
                $noms = $fichiers | ForEach-Object { $_.Name }
                $orphelins = @(Get-ChildItem -LiteralPath $sortie -File -Filter '*.nv' |
                               Where-Object { $noms -notcontains $_.Name })
                foreach ($o in $orphelins) {
                    Write-Warning "$($t.TARGET)\$($o.Name) n est pas dans le modele : il garde l identite de l ancienne cabine"
                }
            }
            # WRITEDIR : le dossier d'ecriture que l'emulateur a amorce depuis
            # ce dossier vivant. Il garde les NVRAM d'avant : on le vide, et
            # l'emulateur le refait depuis les NVRAM posees ici au lancement
            # suivant. Le meme mecanisme que STALE, pour l'etat.
            $ecriture = LireWriteDir
            $aVider = if ($t.WRITEDIR -and $ecriture) { Join-Path $ecriture (ResoudreChemin $t.WRITEDIR $cabCible) } else { $null }
            if ($WhatIf) {
                "[essai] {0} <- {1}  ({2} fichier(s), {3})" -f $t.TARGET, (ResoudreChemin $t.SOURCE $cabCible), $fichiers.Count, $raison
                if ($aVider -and (Test-Path -LiteralPath $aVider)) { "[essai] vide     $aVider" }
            } else {
                if ($recursif -and (Test-Path -LiteralPath $sortie)) { Remove-Item -LiteralPath $sortie -Recurse -Force }
                New-Item -ItemType Directory -Force -Path $sortie | Out-Null
                foreach ($f in $fichiers) {
                    $dest = Join-Path $sortie $f.FullName.Substring($source.TrimEnd('\').Length + 1)
                    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $dest) | Out-Null
                    Copy-Item -LiteralPath $f.FullName -Destination $dest -Force
                }
                Set-Content -LiteralPath $pose -Value $cabCible -Encoding ASCII
                "pose     {0} <- {1}  ({2} fichier(s), {3})" -f $t.TARGET, (ResoudreChemin $t.SOURCE $cabCible), $fichiers.Count, $raison
                if ($aVider -and (Test-Path -LiteralPath $aVider)) {
                    Remove-Item -LiteralPath $aVider -Recurse -Force
                    "vide     $aVider  (l emulateur le refait depuis $($t.TARGET))"
                }
            }
            }
        }

        'XML' {
            # La SOURCE est une table, un profil par ligne : quel fichier, et
            # sous quels noms de champs sa resolution se regle. Voir
            # valeurs\teknoparrot.csv pour le pourquoi de cette table.
            if (-not (Test-Path -LiteralPath $source)) { throw "table absente : $source" }
            $v = ValeursPour $cabCible
            $faits = 0; $absents = 0; $inchanges = 0
            foreach ($g in (LireCsv $source)) {
                $xml = Join-Path $Racine ('Emulators\{0}\UserProfiles\{1}.xml' -f $g.DOSSIER, $g.PROFIL)
                if (-not (Test-Path -LiteralPath $xml)) { $absents++; continue }
                $octets = [IO.File]::ReadAllBytes($xml)
                $bom = $octets.Length -ge 3 -and $octets[0] -eq 0xEF -and $octets[1] -eq 0xBB -and $octets[2] -eq 0xBF
                $debut = if ($bom) { 3 } else { 0 }
                $texte = [Text.Encoding]::UTF8.GetString($octets, $debut, $octets.Length - $debut)
                $avant = $texte
                $texte = EcrireChampXml $texte $g.CHAMP_LARGEUR $v['LARGEUR']
                $texte = EcrireChampXml $texte $g.CHAMP_HAUTEUR $v['HAUTEUR']
                # Le booleen de resolution personnalisee, quand le profil en a
                # un : sans lui, la largeur et la hauteur restent lettre morte.
                if ($g.CHAMP_ACTIVER) { $texte = EcrireChampXml $texte $g.CHAMP_ACTIVER '1' }
                if ($texte -eq $avant) { $inchanges++; continue }
                if (-not $WhatIf) {
                    # Patcher en place supprime le recours a l'original : on en
                    # garde une copie au tout premier passage.
                    $origine = "$xml.origine"
                    if (-not (Test-Path -LiteralPath $origine)) { Copy-Item -LiteralPath $xml $origine }
                    [IO.File]::WriteAllText($xml, $texte, (New-Object Text.UTF8Encoding $bom))
                }
                $faits++
            }
            $prefixe = if ($WhatIf) { '[essai] ' } else { '' }
            "{0}profils  {1} regle(s) a {2}x{3}, {4} deja bon(s), {5} absent(s)" -f
                $prefixe, $faits, $v['LARGEUR'], $v['HAUTEUR'], $inchanges, $absents
        }

        'STALE' {
            # La TARGET, relative au dossier d'ecriture (jokers permis), designe
            # les copies que l'emulateur y a faites de la SOURCE et qu'il lit a
            # la place de l'original (linuxloader : linuxloader.ini, recopie
            # au premier lancement). La SOURCE vient d'etre regeneree par une
            # cible plus haut : une copie qui en differe est effacee, et
            # l'emulateur la refait depuis l'original au lancement suivant.
            # Une copie identique reste. Sans dossier d'ecriture, rien a faire.
            $ecriture = LireWriteDir
            if (-not $ecriture) {
                "garde    {0}  (pas de dossier d ecriture)" -f $t.TARGET
            } else {
                if (-not (Test-Path -LiteralPath $source)) { throw "original absent : $source" }
                $original = [IO.File]::ReadAllText($source) -replace "`r`n", "`n"
                $copies = @(Get-ChildItem -Path (Join-Path $ecriture $t.TARGET) -File -ErrorAction SilentlyContinue)
                $effacees = @($copies | Where-Object { ([IO.File]::ReadAllText($_.FullName) -replace "`r`n", "`n") -ne $original })
                if (-not $WhatIf) { foreach ($c in $effacees) { Remove-Item -LiteralPath $c.FullName -Force } }
                $noms = ($effacees | ForEach-Object { Split-Path -Leaf (Split-Path -Parent $_.FullName) }) -join ', '
                "{0}{1}  ({2} copie(s) dans {3}, {4} {5}{6})" -f $(if ($WhatIf) { '[essai] efface ' } else { 'efface   ' }),
                    $t.TARGET, $copies.Count, $ecriture, $effacees.Count, $(if ($WhatIf) { 'a effacer' } else { 'effacee(s)' }),
                    $(if ($noms) { " : $noms" } else { '' })
            }
        }

        default { throw "$($t.TARGET) : TYPE inconnu '$type'" }
    }
}

EcrireResEnPlace $Res
if (-not $WhatIf) { "resolution en place : $Res   cabine : $Cab" }
