import Control.Monad
import System.Random
import Control.Concurrent
import Control.Concurrent.MVar
import Data.Tuple

type Fork = MVar Int

data Philosopher = Ph String Fork Fork

mkPhilosopher :: String -> Fork -> Fork -> Philosopher
mkPhilosopher name left right = Ph name left right

showph :: Philosopher -> IO String
showph (Ph n l r) =  do
    left <- readMVar l
    right <- readMVar r
    return $ n ++ (show left) ++ (show right)
    
takeFork :: String -> Int -> String
takeFork name i = name ++ " taken a" ++ (show i) ++ " fork"

ph_name = ["Kant", "Aristotle", "Marx", "Russel"]

runPh :: Philosopher -> IO ()
runPh (Ph name l r) = forever $ do
    putStrLn $ name ++ " hungry"
    left <- takeMVar l
    putStrLn $ takeFork name left
    right <- takeMVar r
    putStrLn $ takeFork name right

    putStrLn $ "Eat " ++ name ++ "..."

    delay <- randomRIO (1,5)
    threadDelay (delay * 1000000)
    putStrLn $ "End : " ++ name

    putMVar l left
    putMVar r right
    
solve_deadlock :: [(Fork,Fork)] -> [(Fork, Fork)]
solve_deadlock forks = dijkstra
    where 
        dijkstra = (init forks) ++ [swap $ last forks]

main :: IO ()
main = do
    forks <- mapM (\i -> newMVar i) ([1..4] :: [Int])
    let forkPairs = solve_deadlock $ zip forks (tail . cycle $ forks)
    let phs = map (\(n, (l,r)) -> mkPhilosopher n l r) $ zip ph_name forkPairs
    mapM_ (\ph -> forkIO $ runPh ph) phs
    end <- getLine
    putStrLn "End"
