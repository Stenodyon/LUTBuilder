
/*
    The builder takes care of build origin and direction
*/
public class Builder
{
    public v3 origin;
    public Direction dir;

    public Builder(v3 origin, Direction dir)
    {
        this.origin = origin;
        this.dir = dir;
    }

    public v3 buildSpaceToWorldSpace(v3 a)
    {
        v3 out = new v3(a);
        int temp;
        switch(dir)
        {
            case NORTH:
                out.z = -a.z;
                out.x = -a.x;
                break;
            case EAST:
                temp = out.x;
                out.x = a.z;
                out.z = -temp;
                break;
            case WEST:
                temp = out.x;
                out.x = -a.z;
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

    public void fill(Box area, String block)
    {
        Box _area = buildSpaceToWorldSpace(area);
        typeString("/fill ~" + _area.close.x
            + " ~" + _area.close.y
            + " ~" + _area.close.z
            + " ~" + _area.far.x
            + " ~" + _area.far.y
            + " ~" + _area.far.z
            + " " + block);
    }
}
