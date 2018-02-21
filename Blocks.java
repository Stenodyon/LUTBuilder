
public enum Blocks
{
    AIR ("minecraft:air"),
    IRON ("minecraft:iron_block"),
    REDSTONE ("minecraft:redstone_wire"),
    TORCH ("minecraft:redstone_torch")
    {
        private int[][] torchDir =
        {
            {0, 1, 2, 3, 4},
            {0, 2, 1, 4, 3},
            {0, 4, 3, 1, 2},
            {0, 3, 4, 2, 1}
        };

        @Override public String orient(Direction dir, int blockDir)
        {
            blockDir = torchDir[dir.intValue][blockDir];
            return name + " " + blockDir;
        }
    },
    REPEATER ("minecraft:unpowered_repeater");

    public final String name;
    Blocks(String name) { this.name = name; }

    public String orient(Direction dir, int blockDir)
    {
        switch(dir.intValue)
        {
            case 1:
                blockDir = (blockDir + 2) % 4;
                break;
            case 2:
                blockDir = (blockDir + 3) % 4;
                break;
            case 3:
                blockDir = (blockDir + 1) % 4;
                break;
        }
        return name + " " + blockDir;
    }
}
