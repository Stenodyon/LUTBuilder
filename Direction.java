public enum Direction
{
    NORTH (1),
    SOUTH (0),
    EAST (2),
    WEST (3);

    public int intValue;
    Direction(int value) { this.intValue = value; }

    public static Direction fromFacing(String facing)
    {
        String _facing = facing.toLowerCase();
        if(_facing.startsWith("north"))
            return Direction.NORTH;
        else if(_facing.startsWith("south"))
            return Direction.SOUTH;
        else if(_facing.startsWith("east"))
            return Direction.EAST;
        else if(_facing.startsWith("west"))
            return Direction.WEST;
        throw new IllegalArgumentException(facing);
    }
}
