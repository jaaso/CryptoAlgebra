import CryptoTools
import Data.Ord
import Data.Char
import Data.List

vigenere_encrypt :: String -> [Int] -> String
vigenere_encrypt ptext ks = zipWith shiftLetter (clean ptext) (cycle ks)
  where shiftLetter c x = alphaIdxToChar . shift x . charToAlphaIdx $ c

vigenere_decrypt :: String -> [Int] -> String
vigenere_decrypt ctext ks = vigenere_encrypt ctext (map negate ks)








ex_txt = clean "VVHQWVVRHMUSGJGTHKIHTSSEJGHLSFCBGVWCRLRYQTFSVGAHW"
      ++ "KCUHWAUGLQHNSLRLJSHBLTSPISPRDXLJSVEEGHLQWKASSKUWE"
      ++ "PWqTWVSPGOELKCQYFNSVWLJSNiqKGNRGYBWLWGOVIOKHKAZKQ"
      ++ "KXZGYHCECMEIUJOQKWFWVEFqHKIJRCLRLKBIENQFRJLJSDHGR"
      ++ "HLSFQTWLAUqRHWDMWLGUSGIKKFLRYVCWVSPGPHLKASSJVOqXE"
      ++ "GGVEYGGZMLJCXXLJSVPAIVWIKVRDRYGFRJLJSLVEGGVEYGGEI"
      ++ "APUUISFPBTGNWWMUCZRVTWGLRWUGUMNCZVILE"

vigenere_crack :: String -> String
vigenere_crack ctext = vigenere_decrypt ctext key
    where key = determineKey w (keyLength ctext 10)
          w = letterFreq ctext

letterFreq :: String -> [Double]
letterFreq s = [ (/ fromIntegral (length s)) . fromIntegral. length . filter (== c) $ (map toUpper s) | c <- ['A' .. 'Z']]

determineKey :: [Double] -> Int -> [Int]
determineKey w 0 = []
determineKey w n = k : determineKey w (n-1)
k = undefined -- head $ sortBy maxDot [1..25]

maxDot w x y = dotProd w (a y) `compare` dotProd w (a x)
a i = zipWith const (drop i (cycle ef)) ef
ef = englishFrequencies
dotProd a b = sum (zipWith (*) a b)


keyLength :: String -> Int -> Int
keyLength ctext max_len = head $ sortBy coinceComp [1..max_len]
  where coinceComp x y = coincidences ctext y `compare` coincidences ctext x

coincidences :: String -> Int -> Int
coincidences ctext offset = sum $ zipWith oneIfEqual ctext shifted
    where oneIfEqual a b = if a == b then 1 else 0
          shifted = drop offset . cycle $ ctext
