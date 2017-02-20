import Control.Parallel.Strategies
import System.Environment
import Data.Complex

zetaRange :: (Floating a, Integral b) => a -> (b,b) -> [a]
zetaRange s (x, y) = [ fromIntegral n ** (-s) | n <- [x..y]]

cut ::  Int -> Int -> [(Int, Int)] 
cut n k =
    take m (mkRange 1 (size + 1)) 
    ++
    take (k - m) (mkRange (size * m + 1) size)         
    where           
        (size, m) = n `divMod` k           
        mkRange from size = (from, from + size - 1) : mkRange (from + size) size


getparam :: IO (Int, Int, Complex Double, String) 
getparam = do   
    argv <- getArgs   
    case argv of     
        (t:n:s:strat:[]) -> return (read t, read n, read s, strat)    
        _          -> error "usage: zeta <nthreads> <boundary> <s> <strategy>"  

zeta :: (Floating a, Integral b) => a -> b -> a
zeta s n = fromIntegral n ** (-s)

main :: IO () 
main = do   
    (t, n, s, strat) <- getparam
    let strategy = parse strat
    let ranges = [1..n]
        results = parMap strategy (zeta s) ranges

    print $ sum results
    where
        parse :: (NFData a) => String -> Strategy a
        parse "rpar" = rpar
        parse "rseq" = rseq
        parse "rdeepseq" = rdeepseq
