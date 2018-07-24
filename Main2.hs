module Main(main, PongGame, render, initialState) where

import Graphics.Gloss
import Prelude

data PongGame = Game
 { ballLoc :: (Float, Float) -- ^ Pong ball (x, y) location.
 , ballVel :: (Float, Float) -- ^ Pong ball (x, y) velocity.
 , player1 :: Float	     -- ^ Left player paddle height. Zero is the middle of the screen.
 , player2 :: Float          -- ^ Right player paddle height.
} deriving Show

initialState :: PongGame
initialState = Game
 { ballLoc = (-10, 30)
 , ballVel = (1, -3)
 , player1 = 40
 , player2 = -80
 }

                     -- | Update the ball position using its current velocity.
moveBall :: Float    -- ^ The number of seconds since last update
         -> PongGame -- ^ The initial game state
         -> PongGame -- ^ A new game state with an updated ball position

moveBall seconds game = game { ballLoc = (x', y') }
  where
    -- Old locations and velocities.
    (x, y) = ballLoc game
    (vx, vy) = ballVel game

    -- New locations.
    x' = x + vx * seconds
    y' = y + vy * seconds

width, height, offset :: Int
width = 300
height = 300
offset = 100

render :: PongGame -> Picture
render game = pictures [ball, walls, 
        mkPaddle rose 700 (-20),
        mkPaddle orange (-700) 40]
 where
-- The pong ball.
  ball = translate (-10) 40 $ color ballColor $ circleSolid 10
  ballColor = dark red

-- The bottom and top walls.

  wall :: Float -> Picture
  wall offset = 
   translate 0 offset $ color wallColor $ rectangleSolid 1440 10

  wallColor = greyN 0.5
  walls = pictures [wall 450, wall (-450)]

-- Make a paddle of given border and vertical offset.
  mkPaddle :: Color -> Float -> Float -> Picture
  mkPaddle col x y = pictures
   [ translate x y $ color ballColor $ rectangleSolid 26 86
   , translate x y $ color paddleColor $ rectangleSolid 20 80
   ]

  paddleColor = light (light blue) 

window :: Display
window = FullScreen
-- InWindow "Haskell-Pong" (width, height) (offset, offset)

background :: Color
background = black

-- | Run a finite-time-step simulation in a window.
  simulate :: Display -- ^ How to display the game.
         -> Color   -- ^ Background color.
         -> Int     -- ^ Number of simulation steps to take per second of real time.
         -> a       -- ^ The initial game state. 
         -> (a -> Picture) -- ^ A function to render the game state to a picture. 
         -> (ViewPort -> Float -> a -> a) -- ^ A function to step the game once. 
        -> IO ()

type Radius = Float 
type Position = (Float, Float)

-- | Given position and radius of the ball, return whether a collision occurred.
wallCollision :: Position -> Radius -> Bool 
wallCollision (_, y) radius = topCollision || bottomCollision
  where
    topCollision    = y - radius <= -fromIntegral width / 2 
    bottomCollision = y + radius >=  fromIntegral width / 2

wallBounce :: PongGame -> PongGame
wallBounce game = game { ballVel = (vx, vy') }
  where
    -- Radius. Use the same thing as in `render`.
    radius = 10

    -- The old velocities.
    (vx, vy) = ballVel game

    vy' = if wallCollision (ballLoc game) radius
          then
             -- Update the velocity.
             -vy
           else
            -- Do nothing. Return the old velocity.
            vy

fps :: Int
fps = 60

main :: IO ()
main = simulate window background fps initialState render update

update :: ViewPort -> Float -> PongGame -> PongGame
update _ seconds = wallBounce . moveBall seconds