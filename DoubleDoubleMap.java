
public class DoubleDoubleMap
{
    public static final int DEF_CAPACITY = 3;
    public static final float GROW_PERCENTAGE = 0.75f;
    public static final int GROWTH_RATE = 2;

    protected DoubleDoubleNode[] hashtable;
    protected int size;//use size -1 for % in hashing functions
    protected int used;

    public DoubleDoubleMap(int numItems)
    {
        int newS;

        newS = (numItems <= 0) ? DEF_CAPACITY:NumberUtils.ceilPrime(numItems);

        hashtable = new DoubleDoubleNode[newS];
        size = newS;
        used = 0;
    }

    public void clear()
    {
        for(int i=0;i<size;i++)
        {
            hashtable[i]=null;
        }
        used = 0;
    }

    public int size()
    {
        return used;
    }

    public boolean containsKey(double c)
    {
        return !Double.isNaN(get(c)) ;
    }

    public double get(double c)
    {
        double returnValue = Double.NaN;

        if(used > 0)
        {
            int index;
            DoubleDoubleNode node = null;

            index = ((int)c) % (size - 1);
            node = hashtable[index];

            if(node != null)
            {
                do
                {
                    if(c == node.key)
                    {
                        returnValue = node.value;
                        break;
                    }
                    else
                    {
                        node = node.next;
                    }

                } while(node != null);
            }
        }
        return returnValue;
    }

    public double put(double c, double val)
    {
        int index;
        DoubleDoubleNode node = null;
        double valueToReturn = Double.NaN;
        boolean gotIt = false;

        index = ((int)c) % (size - 1);
        node = hashtable[index];

        if(node != null)
        {
            do
            {
                if(node.key == c)
                {
                    valueToReturn = node.value;//cache the old one and
                    node.value = val;//replace it
                    gotIt = true;
                    break;
                }
                else
                {
                    node = node.next;
                }

            } while(node != null);
        }

        if(!gotIt)
        {

            node = new DoubleDoubleNode();

            node.key = c;
            node.value = val;
            node.next = hashtable[index];

            hashtable[index] = node;

            used++;

            //check if we need to grow
            if(used >= (GROW_PERCENTAGE * size))
            {
                DoubleDoubleNode[] newTable;
                int newS = GROWTH_RATE * size, newUsed = 0;
                DoubleDoubleIterator iterator = new DoubleDoubleIterator(hashtable, size);
                DoubleDoubleNode newNode = null;
                DoubleDoubleNode nextNode = null;
                int curIndex, i;

                newS = NumberUtils.ceilPrime(newS);

                newTable = new DoubleDoubleNode[newS];

                while(iterator.nextState())
                {
                    curIndex = ((int)iterator.key()) % (newS - 1);

                    newNode = new DoubleDoubleNode();

                    newNode.key = iterator.key();
                    newNode.value = iterator.value();
                    newNode.next = newTable[curIndex];
                    newTable[curIndex] = newNode;

                    newUsed++;
                }

                for(i = 0; i < size; i++)
                {
                    newNode = hashtable[i];

                    while(newNode != null)
                    {

                        nextNode = newNode.next;
                        newNode = nextNode;

                    }

                    hashtable[i] = null;
                }

                hashtable = newTable;
                size = newS;
                used = newUsed;
            }
        }
        return valueToReturn;
    }
}

class DoubleDoubleIterator
{
    int curIndex;
    DoubleDoubleNode curNode;
    boolean bumpedCurNode;
    DoubleDoubleNode[] table;
    int tableSize;

    DoubleDoubleIterator(DoubleDoubleNode[] aTable, int aSize)
    {

        table = aTable;
        tableSize = aSize;
        curIndex = -1;
        curNode = null;
        bumpedCurNode = false;
    }

    boolean nextState()
    {
        boolean foundAnotherNode = false;
        DoubleDoubleNode nextNode;

        if(curNode != null)
        {

            if(true == bumpedCurNode)
            {
                foundAnotherNode = true;
            }
            else//we have a node, try to find the next one at that slot
            {
                nextNode = curNode.next;

                if(nextNode != null)//found one in this slot
                {
                    curNode = nextNode;
                    foundAnotherNode = true;
                }
                else//move to the next slot
                {
                    curIndex++;
                }
            }
        }

        if(foundAnotherNode == false)
        {
            if(curIndex == -1) curIndex = 0;

            while(curIndex < tableSize)
            {
                nextNode = table[curIndex];

                if(nextNode != null)
                {
                    curNode = nextNode;
                    foundAnotherNode = true;
                    break;
                }
                else
                {
                    curIndex++;
                }
            }
        }

        bumpedCurNode = false;

        return foundAnotherNode;
    }

    public double key()
    {
        return (curNode == null) ? Double.NaN : curNode.key;
    }

    public double value()
    {
        return (curNode == null) ? Double.NaN : curNode.value;
    }
}

class DoubleDoubleNode
{
    DoubleDoubleNode next;
    double key;
    double value;
}