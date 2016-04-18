-- v celom tomto pr�klade je abeceda ['a'..'z']
-- pripom�name, �e typ String = [Char], teda "ahoj" a ['a','h','o'','j'] s� identick� hodnoty
-- preto s re�azcom pracujeme ako so zoznamom

-- 1bod
-- vr�ti �ubovo�n� re�azec, ktor� sa nenach�dza v nepr�zdnom vstupnom zozname nepr�zdnych re�azcov
-- Pozn�mka: zoznam m��e ma� aj jeden prvok...
unikatny  :: [String] -> String
unikatny [x] = x ++ x
unikatny  xs = concat xs

-- 2body
-- vr�ti zoznam v�etk�ch najdlh��ch re�azov (t.j. maxim�lnej d�ky) zo vstupn�ho zoznamu. Na porad� nez�le��.
najdlhsie  :: [String] -> [String]
najdlhsie xs = filter ( (== maximum (map length xs)) . length) xs


-- 3body
-- na jeden prechod zoznamu
najdlhsie'  :: [String] -> [String]
najdlhsie' xs = fst $ jedenPrechod xs (-1)
    where jedenPrechod [] max = ([], max)
          jedenPrechod (x:xs) max = (if m == max' then x:maxs else maxs, max') 
            where m = length x
                  (maxs, max') = jedenPrechod xs (if m > max then m else max)
            
-- 3body
-- vrati najkratsi neprazdny retazec, ktory sa nenachadza v zozname retazcov
alls = []:[ x:a | a<-alls,x<-['a'..'z']]
najkratsi :: [String] -> String
najkratsi xs = head (filter (`notElem` xs) (tail alls))

