# Activity Tracker and Game

# Activity Tracker:


# The Game
The game will randomly drop "Blocks" and the player must rotate the phone left and right to move the block along the x axis. The Y movment will be constant. The goal is to fit as many blocks on the screen as possible before you loose.

## How you loose
If the block that was spawned does not move and reaches a 0 velocity in the y direction i.e. there are blocks underneath the newly spanned block

## When do blocks spawn?
Blocks spawn when the active block reaches a y velocity of 0 after a little delay. If the block starts moving after the delay then the new block will not spawn and you can continue with the falling block. This would happen if the block that was falling was moved into a position where it can freely fall after the y velocity of 0 was reached.

## Bounding Box
To allow it to be easier on the player to slot blocks together, we used 2 CGMutable Path objects for each of the blocks. One path that defines the blocks image and one path that defines the physics. The Physics is slightly smaller and that is governed by the getDelta() function in BlockBase.

## Blocks
We used the normal Tetris blocks with the following names and shapes
* TBlock
<pre>
    | |
  | | | |
  <\pre>
* LineBlock
  | | | | |
* SBlock TOdO (Check if this is the right order)
  | |
  | | |
    | |
* RSBlock 
    | |
  | | |
  | |
* LBlock
  | |
  | | | |
* RLBlock (Revers LBlock)
      | |
  | | | |
* SquareBlock
  | | |
  | | |

Each of these use the BlockBase Protocol and extenstion, to allow us to use them properly in the code

