import java.util.Stack;

/*
    The builder takes care of build origin and direction
*/
public class Builder
{
    public v3 origin;
    public Direction dir;

    private v3 currentTranlation = v3.zero();
    private Stack<v3> translationStack = new Stack<v3>();

    public Builder(v3 origin, Direction dir)
    {
        this.origin = origin;
        this.dir = dir;
    }

    public void pushTranslation(v3 translation)
    {
        translationStack.push(translation);
        currentTranlation.iadd(translation);
    }

    public void popTranslation()
    {
        if(translationStack.empty())
            return;
        v3 popped = translationStack.pop();
        currentTranlation.isub(popped);
    }

    public v3 buildSpaceToWorldSpace(v3 a)
    {
        v3 out = a.add(currentTranlation);
        int temp;
        switch(dir)
        {
            case NORTH:
                out.z = -out.z;
                out.x = -out.x;
                break;
            case EAST:
                temp = out.x;
                out.x = out.z;
                out.z = -temp;
                break;
            case WEST:
                temp = out.x;
                out.x = -out.z;
                out.z = temp;
                break;
        }
        return out.add(origin);
    }

    public Box buildSpaceToWorldSpace(Box a)
    {
        v3 close = buildSpaceToWorldSpace(a.close);
        v3 far = buildSpaceToWorldSpace(a.far);
        return new Box(close, far);
    }

    public void setBlock(int x, int y, int z, Blocks block)
    {
        setBlock(x, y, z, block, 0);
    }

    public void setBlock(int x, int y, int z, Blocks block, int dir)
    {
        setBlock(new v3(x, y, z), block, dir);
    }

    public void setBlock(v3 pos, Blocks block, int dir)
    {
        v3 _pos = buildSpaceToWorldSpace(pos);
        String _block = block.orient(this.dir, dir);
        typeString("/setblock"
            + " ~" + _pos.x
            + " ~" + _pos.y
            + " ~" + _pos.z
            + " " + _block);
    }

    public void fill(int x1, int y1, int z1, int x2, int y2, int z2, Blocks block)
    {
        v3 a = new v3(x1, y1, z1);
        //println(a.toString());
        v3 b = new v3(x2, y2, z2);
        //println(b.toString());
        Box box = new Box(a, b);
        //println(box.toString());
        fill(box, block);
    }

    public void fill(Box area, Blocks block)
    {
        Box _area = buildSpaceToWorldSpace(area);
        typeString("/fill"
            + " ~" + _area.close.x
            + " ~" + _area.close.y
            + " ~" + _area.close.z
            + " ~" + _area.far.x
            + " ~" + _area.far.y
            + " ~" + _area.far.z
            + " " + block.name);
    }

    public void clone(int x1, int y1, int z1, int x2, int y2, int z2, int x, int y, int z)
    {
        clone(
            new Box(new v3(x1, y1, z1), new v3(x2, y2, z2)),
            new v3(x, y, z));
    }

    public void clone(Box input, v3 pos)
    {
        Box output = input.translate(pos.sub(input.close));
        Box _input = buildSpaceToWorldSpace(input);
        Box _output = buildSpaceToWorldSpace(output);
        v3 _pos = _output.close;
        typeString("/clone"
            + " ~" + _input.close.x
            + " ~" + _input.close.y
            + " ~" + _input.close.z
            + " ~" + _input.far.x
            + " ~" + _input.far.y
            + " ~" + _input.far.z
            + " ~" + _pos.x
            + " ~" + _pos.y
            + " ~" + _pos.z
            + " masked");
    }
}
