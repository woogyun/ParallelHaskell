import System.Environment (getArgs)
import Control.Monad
import Control.Distributed.Process
import Control.Distributed.Process.Closure
import Control.Distributed.Process.Node (initRemoteTable)
import Control.Distributed.Process.Backend.SimpleLocalnet

fibo :: Integer -> Integer
fibo 0 = 1
fibo 1 = 1
fibo n = fibo (n-1) + fibo (n-2)

slave :: ProcessId -> Process ()
slave them = forever $ do
  n <- expect
  send them (fibo n)

remotable ['slave]

-- | Wait for merge list
mergeFiboList :: Int -> Process [Integer]
mergeFiboList = go []
  where
    go :: [Integer] -> Int -> Process [Integer]
    go !acc 0 = return acc
    go !acc n = do
      m <- expect
      go (acc ++ [m]) (n - 1)

master :: Integer -> [NodeId] -> Process [Integer]
master n slaves = do
  us <- getSelfPid

  -- Start slave processes 
  slaveProcesses <- forM slaves $ \nid -> spawn nid ($(mkClosure 'slave) us)

  -- Distribute 1 .. n amongst the slave processes 
  spawnLocal $ forM_ (zip [1 .. n] (cycle slaveProcesses)) $ 
    \(m, them) -> send them m 

  -- Wait for the result
  mergeFiboList (fromIntegral n)

rtable :: RemoteTable
rtable = __remoteTable initRemoteTable 

main :: IO ()
main = do
  args <- getArgs

  case args of
    ["master", host, port, n] -> do
      backend <- initializeBackend host port rtable 
      startMaster backend $ \slaves -> do
        result <- master (read n) slaves
        liftIO $ print result 
    ["slave", host, port] -> do
      backend <- initializeBackend host port rtable 
      startSlave backend
