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
        this.x = copy.x; this.y = copy.y; this.z = copy.z;
    }

    public v3 add(v3 other)
    {
        return new v3(x + other.x, y + other.y, z + other.z);
    }

    public v3 iadd(v3 other)
    {
        x += other.x; y += other.y; z += other.z;
        return this;
    }

    public v3 sub(v3 other)
    {
        return new v3(x - other.x, y - other.y, z - other.z);
    }

    public v3 isub(v3 other)
    {
        x -= other.x; y -= other.y; z -= other.z;
        return this;
    }

    public String toString()
    {
        return "(" + x + ", " + y + ", " + z + ")";
    }

    public static v3 zero()
    {
        return new v3(0, 0, 0);
    }
}
