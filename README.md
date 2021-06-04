# Speed-of-object
Finding pixel and metric speed of object in a video using Matlab

We extracted images from a video and converted them to gray scale. Then we found center location of obect in each frame. Displacement of center using Eucliead distance in each successive frames would give pixel speed of object. Frame rate would give actual metric speed of object.

speed = total_displacement * scale * framerate;
speed_pixels = total_displacement * framerate;
