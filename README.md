# Activity Tracker and Game

# Activity Tracker:
* The Goal will default to 200 the first time the app is loaded, but will write to the user defaults when changed. If for some reason the user defaults are missing after, it will default back to 200.
## External Tools
### Charts Cocoa Pods
We used this tool https://cocoapods.org/pods/Charts to create our charts. If you are using a M1 chip you will need to do the following:
* Launch terminal with rosetta
* Run this command: arch -x86_64 sudo gem install ffi
* Verify this line exists in "pod 'Charts'"
* Then run "pod install" in the rosetta terminal

## Chart Functionality
If the step goal for the chart is not met, the chart will be loaded with two datasets, Steps left in the goal (red) and steps taken (green). If the step goal is met the chart will be loaded with one dataset, steps taken (green)

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
</pre>
* LineBlock
<pre>
  | | | | |
</pre>
* SBlock TOdO (Check if this is the right order)
<pre>
  | |
  | | |
    | |
</pre>
* RSBlock 
<pre>
    | |
  | | |
  | |
</pre>
* LBlock
<pre>
  | |
  | | | |
</pre>
* RLBlock (Revers LBlock)
<pre>
      | |
  | | | |
</pre>
* SquareBlock
<pre>
  | | |
  | | |
</pre>
Each of these use the BlockBase Protocol and extenstion, to allow us to use them properly in the code.

## Swapping 
Based off how many steps the user took, they will be allowed to swap a certian number of blocks at any time during that bloks decent, but before it stops falling in the y direction.
