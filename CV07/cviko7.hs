-- preliezanie vyrazov
-- lambda kodovanie logickych vyrazov
-- zoznamy
-- Y
-- stromy (este stale)
{-
logicke hodnoty

namiesto if P then Q else Read je COND P Q R
COND = \P.\Q.\R.(P Q R)
chceme aby (namiesto True budeme pisat len T a namiesto False len F)
COND T Q R -> Q
COND F Q R -> R 
tak�e T mus� by� funkcia \x.\y.x (vr�ti prv� argument) a 
F zasa \x.\y.y (vr�ti druh� argument)

COND TRUE A B =
(\p.\q.\r.(p q r))(\x.\y.x) A B =
(\q.\r.(\x.\y.x) q r) A B =
(\r.(\x.\y.x) A r) B =
(\x.\y.x) A B =
A (ako sme cakali)

teraz skusme OR, AND, NOT,...
hint: na co sa da mozeme pouzit COND
to je si dobre uvedomit:
pravda OR hocico = pravda
nepravda OR hocico = hocico

pravda AND hocico = hocico
nepravda AND hocico = nepravda

Najlahsi asi bude NOT, ked vyuzijeme COND
NOT X = COND X (NOT X) X - rekurzia :-(, 
ale hne� si uvedom�me, �e X je bu� T alebo F
teda h�ad�me funkciu, ktor� ke� dostane T vr�ti F a naopak - no samozrejme NOT
NOT x = \x.(x F T)

teraz mozeme sk�si� napr. AND
AND AB = COND A B FALSE  (to sme len prep�sali, �o plat� pre AND)
dosad�me
\A.\B.((\p.\q.\r.p q r) A B F) =
\A.\B.((\q.\r.A q r) B F) =
\A.\B.(A B F)

a OR analogicky
OR A B = COND A T B
dosad�me
\A.\B.((\p.\q.\r.p q r) A T B) =
\A.\B.((\q.\r.A q r) T B) =
\A.\B.((\r.A T r) B) =
\A.\B.(A T B)

m��eme sk�si�
T AND F =
\A.\B.(A B F) T F =
T F F = 
dosad�me aj za T a F
(\x.\y.x) (\x.\y.y) (\x.\y.y) =
(\y.(\x.\y.y))(\x.\y.y) =
(\x.\y.y) 
�o je ozaj F, ako o�ak�vame

T AND T =
\A.\B.(A B F) T T =
T T F = 
(\x.\y.x) (\x.\y.x) (\x.\y.y) =
(\y.(\x.\y.x))(\x.\y.y) =
(\x.\y.x) �o je T.

OR si m��ete sk�si�

zoznamy

zauj�ma n�s:
 �o je pr�zdny zoznam NIL ([])?
 �o je kon�truktor vytv�rania zoznamu CONS (:)?
 
vieme, �e pre zoznam plat� CONS A B je nepr�zdny zoznam
a HD (CONS A B) = A a TL (CONS A B) = B,
kde HD je hlava (prv� prvok) zoznamu a TL chvost (zvy�ok) zoznamu
CONS teda mus� vr�ti� funkciu, ktor� o�ak�va hlavu a chvost zoznamu a e�te aj selektor, 
ktor� sa aplikuje v na vytvoren� zoznam niekdy v bud�cnosti.
teda
CONS je \h.\t.\s.(s h t)
tak�e selektor vyberie bu� h alebo t. Ale ve� to predsa rob� presne T a F.
HD = \L.(L T)
TL = \L.(L F)

sk�sime
HD (CONS A B) =
dosad�me
(\L.(L T))((\h.\t.\s.(s h t)) A B) =
((\t.\s.(s A t)) B) T =
(\s.(s A B)) T =
T A B =
A, ako sme aj o�ak�vali

e�te n�m ostal test �i je zoznam pr�zdny (NULL) a defin�cia pr�zdneho zoznamu (NIL).
NULL (CONS A B) mus� ma� hodnotu F
rozp�eme a pok�sime sa zjednodu�i�
NULL ((\h.\t.\s.(s h t)) A B) =
NULL (\s.(s A B))
NULL mus� teda by� funkcia, ktor� ke� dostane (\s.(s A B)), vr�ti F.
Nem��e to by� \x.F, lebo by nerozli�ovala �i dostane pr�zdny alebo nepr�zdny zoznam.
Tak�e mus� nejako zmysluplne spracova� argument. 
Napr�klad takto:
(podobne ako zoznamov� selektory)
NULL=\L.L(\h.\t.F), teda ak dostane zoznam vytvoren� kon�truktorom CONS pou�ije �pecialny selektor, 
ktor� "ignoruje" hlavu aj chvost zoznamu a vr�ti F, lebo zoznam bol nepr�zdny.

A ako bude vyzera� pr�zdny zoznam NIL?
NULL NIL m� by� T
ale u� vieme �o je NULL, tak m��eme dostadi�:
\L.L(\h.\t.F) NIL
Teda NIL m� by� funkcia ktor� ak aplikujeme na (\h.\t.F) dostaneme T.
Priamo�iare rie�enie je argument ignorova� a vr�ti� T
Teda
NIL = \x.T

pr�klad:
na lambdy rozp�eme a� ke� bude treba, kv�li preh�adnosti
NULL (TL (CONS A NIL)) =
(\L.L(\h.\t.F)) (TL (CONS A NIL)) =
(TL (CONS A NIL)) (\h.\t.F) =
((\L.(L F))(CONS A NIL)) (\h.\t.F) =
((CONS A NIL) F) (\h.\t.F) =
(((\h.\t.\s.(s h t)) A NIL) F) (\h.\t.F) =
((\s.(s A NIL)) F) (\h.\t.F) =
(F A NIL) (\h.\t.F) =
((\x.\y.y) A NIL) (\h.\t.F) =
NIL (\h.\t.F) =
(\x.T) (\h.\t.F) =
T, ako sme aj o�ak�vali.

-}


--rozcvicka
import TypyTree
-- module TypyTree where
-- data Tree a = Empty | Branch a (Tree a) (Tree a)
--   deriving (Read, Show)
  
-- Nap�te funkciu jeVyvazeny :: Tree a -> Bool
-- ktor� vr�ti True, ked sa v��ka �iadnych dvoch bratov nel�i viac ne� o 1. 
-- Inak vr�ti False.  
jeVyvazeny :: Tree a -> Bool
jeVyvazeny = fst . jeVyvazeny'

jeVyvazeny' :: Tree a -> (Bool, Int)
jeVyvazeny' Empty = (True, 0)
jeVyvazeny' (Branch _ t1 t2) = (r1 && r2 && abs(h1 - h2) < 2, max h1 h2 + 1)
  where (r1, h1) = jeVyvazeny' t1
        (r2, h2) = jeVyvazeny' t2

s1 = Empty
s2 = Branch 1 s1 s1
s3 = Branch 2 s1 s2
s4 = Branch 3 s1 s2        
s5 = Branch 4 s2 s3
s6 = Branch 5 s4 s5
s7 = Branch 7 s1 s6 -- nevyvazeny
s8 = Branch 8 s6 s5
s9 = Branch 9 s8 s5 -- nevyvazeny
s10 = Branch 10 s9 s7 -- nevyvazeny
