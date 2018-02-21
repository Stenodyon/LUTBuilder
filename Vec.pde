/* 3D Vector */
public class v3
{
    int x, y, z;

    public v3(int x, int y, int z)
    {
        this.x = x; this.y = y; this.z = z;
    }

    public v3(v3 copy)
    {
        this.x = copy.x; this.y = copy.y; this.z = copy.y;
    }

    public v3 add(v3 other)
    {
        return new v3(x + other.x, y + other.y, z + other.z);
    }

    public v3 sub(v3 other)
    {
        return new v3(x - other.x, y - other.y, z - other.z);
    }
}