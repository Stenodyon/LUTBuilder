/*
    Represents a 3D box
*/
public class Box
{
    public v3 close, far;

    public Box(v3 a, v3 b)
    {
        close = new v3(a); far = new v3(b);
        if(close.x > far.x)
        {
            close.x = b.x;
            far.x = a.x;
        }
        if(close.y > far.y)
        {
            close.y = b.y;
            far.y = a.y;
        }
        if(close.z > far.z)
        {
            close.z = b.z;
            far.z = a.z;
        }
    }
}
