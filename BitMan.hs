module BitMan where

import Prelude hiding ((||), or, (&&), and, xor)
import Data.Char ( ord, chr )

type Bit = Int
newtype BinaryWord = BinaryWord {toList :: [Bit]}

instance Show BinaryWord where
  show b = splitByFour $ concatMap show (toList b)

-- Separa el String en nibles 
splitByFour :: String -> String
splitByFour [] = []
splitByFour [s1,s2,s3,s4] = [s1,s2,s3,s4]
splitByFour xs = take 4 xs ++ " " ++ splitByFour (drop 4 xs)

-- insert un bit msb a una palabra
insert :: Bit -> BinaryWord -> BinaryWord
insert b bits = if b == 1 then BinaryWord (1 : toList bits)
                else BinaryWord (0 : toList bits)

-- palabra vacia 
empty :: BinaryWord
empty = BinaryWord []

-- Convertir de Int a BinaryWord
intToBinaryWord :: Int -> BinaryWord
intToBinaryWord n = BinaryWord ( toBinary n (cantidadBits (2^k - 1))) where
  r = length (cantidadBits n)
  s = if r `mod` 8 == 0 then 0 else 1
  k = (r `div` 8 + s) * 8

-- Convertir de BinaryWord a Int
binaryWordToInt :: BinaryWord -> Int
binaryWordToInt b = sum (zipWith (*) (reverse (take (length (toList b)) (map (2^) [0 .. ]))) (toList b))

binaryWordToChar :: BinaryWord -> Char
binaryWordToChar b = chr (binaryWordToInt b)

-- Genera lista con potencias de 2 menores a n [..,32,16,8,4,2,1]
cantidadBits :: Int -> [Int]
cantidadBits n = reverse (takeWhile (n>=) (map (2^) [0 .. ]))

-- Genera lista con los bits [msb,...,lsb]
toBinary :: Int -> [Int] -> [Bit]
toBinary _ [] = []
toBinary n (x:xs) = (n `div` x ) : toBinary (n - n `div` x * x) xs

-- completa con ceros hasta llegar a la longitud de palabra deseada. n nro de bits deseados, xs palabra
fillWZeros :: Int -> BinaryWord -> BinaryWord
fillWZeros n xs = BinaryWord(replicate (n - length (toList xs)) 0 ++ toList xs)

--Donvertir de Char a Int (ASCII desplazado)
charToBinaryWord :: Char -> BinaryWord
charToBinaryWord = intToBinaryWord . ord

xorEncrypt :: String -> String -> String
xorEncrypt pwd txt = map binaryWordToChar (zipWith (¬) [charToBinaryWord p | p <- cycle pwd] [charToBinaryWord t | t <- txt])

-- Logical ops

(||) :: Bit -> Bit -> Bit
0 || 0 = 0
_ || _ = 1

or :: BinaryWord -> BinaryWord -> BinaryWord
a `or` b = BinaryWord (zipWith (||) (toList a) (toList b))

(&&) :: Bit -> Bit -> Bit
0 && _ = 0
1 && n = n

and :: BinaryWord -> BinaryWord -> BinaryWord
a `and` b = BinaryWord (zipWith (&&) (toList a) (toList b))

xor :: Bit -> Bit -> Bit
0 `xor` 0 = 0
1 `xor` 1 = 0
_ `xor` _ = 1

(¬) :: BinaryWord -> BinaryWord -> BinaryWord
a ¬ b = BinaryWord (zipWith xor (toList a) (toList b))
