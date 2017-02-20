import Control.Parallel.Strategies
import System.Environment
import Fibo

main :: IO () 
main = do 
    args <- getArgs
    let list = [1..40]

    case args of
        ["seq"] -> do
            let results = map fibo list
            print results
        ["par"] -> do
            let results = parMap rseq fibo list
            print results
