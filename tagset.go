
import ()

const DEF_CAPACITY = 21
const GROW_PERCENTAGE = 0.75
const GROWTH_RATE = 2

type tagSetNode struct {
	next *tagSetNode
	key  string
}

type TagSet struct {
	nodes []*tagSetNode
	size  int32
	used  int32
}

func CreateTagSet(initialSize int32) *TagSet {

	var size int32

	set := new(TagSet)

	if initialSize <= 0 {
		size = DEF_CAPACITY
	} else {
		size = initialSize
	}

	set.nodes = make([]*tagSetNode, size)
	set.size = size
	set.used = 0

	return set
}

func (set *TagSet) Clear() {
	set.used = 0
	set.nodes = make([]*tagSetNode, set.size)
}

func (set *TagSet) Size() int32 {
	return set.used
}

func (set *TagSet) Contains(key string) bool {
	if set.used > 0 {
		index := set.hash(key) % uint32(set.size)

		for node := set.nodes[index]; node != nil; node = node.next {
			if key == node.key {
				return true
			}
		}
	}

	return false
}

//implements the java string hash
func (set *TagSet) hash(key string) uint32 {
	var val uint32 = 1
	var l = len(key)

	for i := 0; i < l; i = i + 1 {
		val += (val * 37) + uint32(key[i])
	}
	return val
}

func (set *TagSet) Remove(key string) bool {
	if set.used > 0 {
		var prev *tagSetNode

		index := set.hash(key) % uint32(set.size)

		for node := set.nodes[index]; node != nil; node = node.next {
			if key == node.key {
				if prev == nil {
					set.nodes[index] = node.next
				} else {
					prev.next = node.next
				}

				return true
			}

			prev = node
		}
	}

	return false
}

func (set *TagSet) Add(key string) {
	var node *tagSetNode

	index := set.hash(key) % uint32(set.size)

	for node = set.nodes[index]; node != nil; node = node.next {
		if key == node.key {
			return
		}
	}

	node = new(tagSetNode)

	node.key = key
	node.next = set.nodes[index]
	set.nodes[index] = node

	set.used = set.used + 1

	//check if we need to grow
	if set.used >= int32(GROW_PERCENTAGE*float64(set.size)) {
		newUsed := 0
		newSize := GROWTH_RATE * set.size
		newTable := make([]*tagSetNode, newSize)
		size := int(set.size)

		for i := 0; i < size; i = i + 1 {

			for oldNode := set.nodes[i]; oldNode != nil; {
				nextNode := oldNode.next
				oldNode.next = nil

				newNode := new(tagSetNode)
				newNode.key = oldNode.key

				newIndex := set.hash(newNode.key) % uint32(newSize)
				newNode.next = newTable[newIndex]
				newTable[newIndex] = newNode

				newUsed = newUsed + 1
				oldNode = nextNode
			}

			set.nodes[i] = nil
		}

		set.nodes = newTable
		set.size = int32(newSize)
		set.used = int32(newUsed)
	}
}
