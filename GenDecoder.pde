void genDecoder(String path, String facing, String reference, String side)
{
    DecoderGenerator generator = new DecoderGenerator(path, facing, reference, side);
    generator.generate();
}

public class DecoderGenerator
{
    Boolean right;
    int[][] modules;
    Builder builder;

    public DecoderGenerator(String path, String facing, String reference, String side)
    {
        right = side == "RIGHT";
        String[] lines = loadStrings(path);
        parseModules(lines);
        println("File parsed");
        Direction dir = Direction.fromFacing(facing);
        builder = new Builder(new v3(0, 0, 0), dir);
    }

    public void generate()
    {
        solveModules();
        println("Problems solved");
        println("Building stated at " + hour() + ":" + minute() + "." + second());
        splash = "Building output lanes";
        buildOutput();
        splash = "Building logic modules";
        buildModules();
        splash = "Placing repeaters";
        placeRepeaters();
        println("Building finished at " + hour() + ":" + minute() + "." + second());
    }

    void parseModules(String[] lines)
    {
        int width = lines[0].length();
        int height = lines.length;
        String lastLine = lines[lines.length-1].toLowerCase();
        modules = new int[height][width];
        for(int lineIndex = 0; lineIndex < height; lineIndex++)
        {
            String line = lines[lineIndex];
            if(line.length() != width)
            {
                println("Parse error: not all lines are of same length");
                exit();
            }
            for(int moduleIndex = 0; moduleIndex < width; moduleIndex++)
            {
                int c = line.charAt(moduleIndex);
                switch(c)
                {
                    case '0':
                        modules[lineIndex][width - 1 - moduleIndex] = 2;
                        break;
                    case '1':
                        modules[lineIndex][width - 1 - moduleIndex] = 1;
                        break;
                    case 'X':
                        modules[lineIndex][width - 1 - moduleIndex] = 0;
                        break;
                    default:
                        println("Parse error: unexpected '" + (char)c + "'");
                        exit();
                }
            }
        }
    }

    void solveModules()
    {
        for(int y = modules.length - 1; y > 0; y--)
        {
            for(int x = 0; x < modules[0].length; x++)
            {
                if(modules[y][x] == 2 && modules[y-1][x] == 2)
                {
                    modules[y-1][x] = 0;
                    modules[y][x] = 3;
                }
            }
        }
        for(int y = modules.length - 1; y > 0; y--)
        {
            for(int x = 0; x < modules[0].length - 1; x++)
            {
                if(modules[y][x] == 3 && modules[y][x+1] == 3)
                {
                    modules[y-1][x] = 4;
                    modules[y-1][x + 1] = 5;
                    modules[y][x] = 6;
                    modules[y][x + 1] = 7;
                }
            }
        }
    }

    void buildOutputLane(int Y)
    {
        int length = modules[0].length * 2;
        builder.fill(length + 2, -4, Y + 1, 2, -4, Y + 1, Blocks.IRON);
        builder.fill(length + 2, -3, Y + 1, 2, -3, Y + 1, Blocks.REDSTONE);
        int torchX = right ? 1 : length + 3;
        int torchDir = right ? 2 : 1;
        builder.setBlock(torchX, -4, Y + 1, Blocks.TORCH, torchDir);
    }

    void copyOutputLanes(int count, int Y)
    {
        int length = modules[0].length * 2;
        int depth = count * 2 - 1;
        builder.clone(
            length + 3, -4, 2 ,
            1, -3, 2 + depth,
            1, -4, Y);
    }

    void buildOutput()
    {
        progress = 0f;
        buildOutputLane(2);
        int availableLanes = 1;
        int leftToBuild = modules.length - 1;
        int y = 1;
        while(leftToBuild > 0)
        {
            progress = 1f - ((float)leftToBuild / modules.length);
            int toCopy = min(availableLanes, leftToBuild);
            copyOutputLanes(toCopy, y * 2 + 2);
            availableLanes += toCopy;
            leftToBuild -= toCopy;
            y += toCopy;
            //println("Built output lane " + (y+1) + " of " + modules.length);
        }
    }

    void buildModule0(int x, int y)
    {
        int X = x * 2;
        int Y = y * 2;
        builder.fill(X, -2, Y, X, -2, Y + 1, Blocks.IRON);
        builder.fill(X, -1, Y, X, -1, Y + 1, Blocks.REDSTONE);
    }

    void buildModule1(int x, int y)
    {
        builder.fill(x * 2, -2, y * 2, x * 2, -2, y * 2 + 1, Blocks.IRON);
        builder.fill(x * 2, -1, y * 2, x * 2, -1, y * 2 + 1, Blocks.REDSTONE);
        builder.setBlock(x * 2 + 1, -2, y * 2 + 1, Blocks.TORCH, 1);
    }

    void buildModule2(int x, int y)
    {
        builder.setBlock(x * 2, -2, y * 2 + 1, Blocks.IRON);
        builder.setBlock(x * 2, -3, y * 2, Blocks.IRON);
        builder.setBlock(x * 2, -2, y * 2, Blocks.REPEATER, 2);
        builder.fill(x * 2, -1, y * 2, x * 2, -1, y * 2 + 1, Blocks.IRON);
        builder.fill(x * 2, 0, y * 2, x * 2, 0, y * 2 + 1, Blocks.REDSTONE);
    }

    void buildModule3(int x, int y)
    {
        int X = x * 2;
        int Y = y * 2;
        builder.setBlock(X, -2, Y + 1, Blocks.IRON);
        builder.setBlock(X, -3, Y, Blocks.IRON);
        builder.setBlock(X, -1, Y + 1, Blocks.REDSTONE);
        builder.setBlock(X, -2, Y, Blocks.REDSTONE);
        builder.setBlock(X + 1, -4, Y, Blocks.IRON);
        builder.setBlock(X + 1, -3, Y, Blocks.REPEATER, 1);
        builder.setBlock(X + 2, -3, Y, Blocks.IRON);
    }

    void buildModule4(int x, int y)
    {
        int X = x * 2;
        int Y = y * 2;
        builder.setBlock(X, -1, Y, Blocks.IRON);
        builder.setBlock(X, 0, Y, Blocks.REDSTONE);

        builder.fill(X + 1, -2, Y + 1, X, -2, Y + 1, Blocks.IRON);
        builder.fill(X + 1, -1, Y + 1, X, -1, Y + 1, Blocks.REDSTONE);

        builder.setBlock(X, 0, Y + 1, Blocks.IRON);
        builder.setBlock(X, 1, Y + 1, Blocks.REDSTONE);
    }

    void buildModule5(int x, int y)
    {
        int X = x * 2;
        int Y = y * 2;
        builder.setBlock(X, -1, Y, Blocks.IRON);
        builder.setBlock(X, 0, Y, Blocks.REDSTONE);

        builder.setBlock(X, -2, Y + 1, Blocks.IRON);
        builder.setBlock(X, -1, Y + 1, Blocks.REDSTONE);

        builder.setBlock(X, 0, Y + 1, Blocks.IRON);
        builder.setBlock(X, 1, Y + 1, Blocks.REDSTONE);
    }

    void buildModule6(int x, int y)
    {
        int X = x * 2;
        int Y = y * 2;
        builder.fill(X, -3, Y, X, -1, Y, Blocks.IRON);
        builder.setBlock(X, -2, Y, Blocks.REPEATER, 0);
        builder.setBlock(X, 0, Y, Blocks.REDSTONE);

        builder.setBlock(X, -2, Y + 1, Blocks.IRON);
        builder.setBlock(X, -1, Y + 1, Blocks.REDSTONE);
        builder.setBlock(X + 1, -3, Y, Blocks.IRON);
        builder.setBlock(X + 1, -2, Y, Blocks.REDSTONE);
    }

    void buildModule7(int x, int y)
    {
        int X = x * 2;
        int Y = y * 2;
        builder.fill(X, -3, Y, X, -1, Y, Blocks.IRON);
        builder.setBlock(X, -2, Y, Blocks.REPEATER, 0);
        builder.setBlock(X, 0, Y, Blocks.REDSTONE);

        builder.setBlock(X, -2, Y + 1, Blocks.IRON);
        builder.setBlock(X, -1, Y + 1, Blocks.REDSTONE);
    }

    void copyModule(int xsrc, int ysrc, int xdest, int ydest)
    {
        int Xsrc = xsrc * 2;
        int Ysrc = ysrc * 2;
        int Xdest = xdest * 2;
        int Ydest = ydest * 2;
        builder.clone(Xsrc, -4, Ysrc,
                Xsrc + 1, 1, Ysrc + 1,
                Xdest, -4, Ydest);
    }

    void copyModuleLine(int xsrc, int ysrc, int count, int xdest, int ydest)
    {
        int Xsrc = xsrc * 2;
        int Ysrc = ysrc * 2;
        int Xdest = xdest * 2;
        int Ydest = ydest * 2;
        builder.clone(Xsrc, -4, Ysrc,
                Xsrc + 2 * count + 1, 1, Ysrc + 1,
                Xdest, -4, Ydest);
    }

    int[] moduleLocationX;
    int[] moduleLocationY;

    void buildInput()
    {
        progress = 0f;
        builder.fill(2, -2, 0, 2, -2, 1, Blocks.IRON);
        builder.setBlock(2, -1, 0, Blocks.REPEATER, 2);
        builder.setBlock(2, -1, 1, Blocks.REDSTONE);
        int availableLanes = 1;
        int leftToBuild = modules[0].length - 1;
        int x = 1;
        while(leftToBuild > 0)
        {
            progress = 1f - ((float)leftToBuild / modules.length);
            int toCopy = min(availableLanes, leftToBuild);
            int depth = toCopy * 2 - 1;
            builder.clone(2, -2, 0, 2 + depth, -1, 1, x * 2 + 2, -2, 0);
            availableLanes += toCopy;
            leftToBuild -= toCopy;
            x += toCopy;
        }
        progress = 1f;
    }

    void buildModules()
    {
        progress = 0f;
        moduleLocationX = new int[8];
        moduleLocationY = new int[8];
        for(int y = 0; y < modules.length; y++)
        {
            for(int x = 0; x < modules[y].length; x++)
            {
                int besty = 0;
                int bestcount = 0;
                for(int py = y - 1; py >= 0; py--)
                {
                    if(modules[y][x] == modules[py][x])
                    {
                        int px = x;
                        for(; px < modules[y].length && modules[y][px] == modules[py][px]; px++);
                        int count = px - x - 1;
                        if(count > bestcount)
                        {
                            bestcount = count;
                            besty = py;
                        }
                    }
                }
                if(bestcount > 1)
                {
                    copyModuleLine(x + 1, besty + 1, bestcount,
                            x + 1, y + 1);
                    x += bestcount;
                    if(x >= modules[y].length)
                        break;
                }

                int module = modules[y][x];
                switch(module)
                {
                    case 0:
                        if(moduleLocationX[module] == 0 && moduleLocationY[module] == 0)
                            buildModule0(x + 1, y + 1);
                        else
                            copyModule(moduleLocationX[module], moduleLocationY[module],
                                    x + 1, y + 1);
                        break;
                    case 1:
                        if(moduleLocationX[module] == 0 && moduleLocationY[module] == 0)
                            buildModule1(x + 1, y + 1);
                        else
                            copyModule(moduleLocationX[module], moduleLocationY[module],
                                    x + 1, y + 1);
                        break;
                    case 2:
                        if(moduleLocationX[module] == 0 && moduleLocationY[module] == 0)
                            buildModule2(x + 1, y + 1);
                        else
                            copyModule(moduleLocationX[module], moduleLocationY[module],
                                    x + 1, y + 1);
                        break;
                    case 3:
                        if(moduleLocationX[module] == 0 && moduleLocationY[module] == 0)
                        {
                            buildModule3(x + 1, y + 1);
                        }
                        else
                        {
                            copyModule(moduleLocationX[module], moduleLocationY[module],
                                    x + 1, y + 1);
                            builder.setBlock(x * 2 + 4, -3, y * 2 + 2, Blocks.IRON);
                        }
                        break;
                    case 4:
                        if(moduleLocationX[module] == 0 && moduleLocationY[module] == 0)
                            buildModule4(x + 1, y + 1);
                        else
                            copyModule(moduleLocationX[module], moduleLocationY[module],
                                    x + 1, y + 1);
                        break;
                    case 5:
                        if(moduleLocationX[module] == 0 && moduleLocationY[module] == 0)
                            buildModule5(x + 1, y + 1);
                        else
                            copyModule(moduleLocationX[module], moduleLocationY[module],
                                    x + 1, y + 1);
                        break;
                    case 6:
                        if(moduleLocationX[module] == 0 && moduleLocationY[module] == 0)
                            buildModule6(x + 1, y + 1);
                        else
                            copyModule(moduleLocationX[module], moduleLocationY[module],
                                    x + 1, y + 1);
                        break;
                    case 7:
                        if(moduleLocationX[module] == 0 && moduleLocationY[module] == 0)
                            buildModule7(x + 1, y + 1);
                        else
                            copyModule(moduleLocationX[module], moduleLocationY[module],
                                    x + 1, y + 1);
                        break;
                }
                if(moduleLocationX[module] == 0 && moduleLocationY[module] == 0)
                {
                    moduleLocationX[module] = x + 1;
                    moduleLocationY[module] = y + 1;
                }
            }
            progress = (float)(y + 1) / modules.length;
            //println("Built row " + (y + 1) + " of " + modules.length);
        }
        splash = "Building input";
        buildInput();
        progress = 1f;
    }

    void placeRepeaters()
    {
        progress = 0f;
        // Input Lanes
        for(int x = 0; x < modules[0].length; x++)
        {
            int X = x * 2 + 2;
            for(int y = 7; y < modules.length; y += 7)
            {
                int module = modules[y][x];
                if(module == 4 || module == 5)
                    y--;
                module = modules[y][x];
                int Y = y * 2 + 2;
                switch(module)
                {
                    case 0:
                    case 1:
                        builder.setBlock(X, -1, Y, Blocks.REPEATER, 2);
                        break;
                    case 2:
                        builder.fill(X, 0, Y, X, -1, Y + 1, Blocks.AIR);
                        builder.setBlock(X, -1, Y + 1, Blocks.REDSTONE);
                        break;
                    case 3:
                        builder.setBlock(X, -1, Y - 1, Blocks.REPEATER, 2);
                        builder.setBlock(X, -1, Y, Blocks.IRON);
                        break;
                    case 6:
                    case 7:
                        builder.setBlock(X, 0, Y, Blocks.REPEATER, 2);
                        builder.setBlock(X, 0, Y + 1, Blocks.IRON);
                        break;
                }
            }
        }
        progress = .5f;
        // Output Lanes
        int repeaterDir = right ? 3 : 1;
        for(int x = 7; x < modules[0].length; x += 7)
        {
            int X = x * 2 + 2;
            for(int y = 0; y < modules.length; y++)
            {
                int Y = y * 2 + 2;
                int module = modules[y][x];
                switch(module)
                {
                    case 1:
                    case 6:
                        builder.setBlock(X, -3, Y + 1, Blocks.REPEATER, repeaterDir);
                        break;
                    default:
                        builder.setBlock(X + 1, -3, Y + 1, Blocks.REPEATER, repeaterDir);
                        break;
                }
            }
        }
        progress = 1f;
    }
}
