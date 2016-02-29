module Obrazok where

type Obr = [[ Char ]]

nad :: Obr -> Obr -> Obr
nad = (++)

-- horizont�lna symetria
prevratH :: Obr -> Obr
prevratH = reverse

-- vertik�lna symetria
prevratV :: Obr -> Obr
-- prevratV obr = [reverse riadok | riadok <- obr]
prevratV obr = map reverse obr

-- zlep� dva obr�zky horizont�lne ved�a seba, ale musia by� rovnako vysok�
vedla :: Obr -> Obr -> Obr
vedla lavyObr pravyObr = [(lavyRiadok ++ pravyRiadok) | 
                          (lavyRiadok, pravyRiadok) <- zip lavyObr pravyObr]

-- prema�uje x na . a naopak
vymenZnak :: Char -> Char
vymenZnak znak = if znak == 'x' then '.' else 'x'

-- prema�uje v matici x na . a naopak
vymenFarby :: Obr -> Obr

-- vymenFarby obr = [[ vymenZnak znak | znak <- riadok] | riadok <- obr]
vymenFarby obr = map (map vymenZnak) obr

-- vytlac na konzolu
zobrazObr :: Obr -> IO()
zobrazObr = putStr . concat . map (++ "\n")

----------- a toto mate dodefinovat...
zlozZnaky :: Char -> Char -> Char
zlozZnaky znak1 znak2 = undefined

zlozObrazky :: Obr -> Obr -> Obr
zlozObrazky obr1 obr2 = undefined

obr1 = ["..xx", "xx..", ".x.x"]
obr2 = ["x.....","x.....","xxxxxx"]

-- zlozObrazky (prevratV obr2) (prevratH obr2) je ["xxxxxx","x....x","xxxxxx"]

ob3 = ["x..","x..","xxx"]
