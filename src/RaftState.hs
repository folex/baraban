{-# LANGUAGE GADTs                      #-}

module RaftState where

import           Proto.Raft.Raft        (RaftMessage'Value(..))

data Follower
data VotedFollower -- has voted on current term
data Candidate
data Leader

-- Connection TODO: how to manage connections? With a separate inner FSM?
class Connection c where
  messages :: c -> IO [RaftMessage'Value]

-- Description of each node's data:
-- - Connections with other nodes; TODO: associate each connection with NodeID?
data Node where Node :: (Connection c) => [c] -> Node

newtype Term = Term Int
newtype NodeID = NodeID String --TODO: or UUID




-- === Follower - initial
-- - Follower -> Candidate after timeout (randomized 150ms – 300ms)

-- === Candidate
-- - If followers don't hear from a leader then they can become a candidate
-- ... and increment election term
-- - Votes for himself
-- - Sends `Request Vote` message to others, nodes will reply with their vote

-- On majority votes, Candidate -> Leader (elected)

-- If the node (Follower, Candidate, Leader?) hasn't voted on current term, it votes for first received `Request Vote`
-- ... and resets its timeout

-- === Leader
-- - The candidate becomes the leader if it gets votes from a majority of nodes.


-- TODO:
-- - LogEntries:
--    - replication,
--    - not-commited
--    - committed – leader waits for majority, notify followers after commit
--    - revert on split brain
