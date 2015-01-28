
import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestSetAddContains(t *testing.T) {
	theSet := CreateTagSet(0)

	theSet.Add("alpha")

	assert.Equal(t, theSet.Contains("alpha"), true, "Set should contain something that was added.")
	assert.Equal(t, theSet.Contains("Alpha"), false, "Set should not contain something that was not added.")
}

func TestSetAddRemove(t *testing.T) {
	theSet := CreateTagSet(0)

	theSet.Add("alpha")

	assert.Equal(t, theSet.Contains("alpha"), true, "Set should contain something that was added.")

	theSet.Remove("alpha")

	assert.Equal(t, theSet.Contains("alpha"), false, "Set should not contain something that was removed.")
}

func TestSetMultipleAddContains(t *testing.T) {
	theSet := CreateTagSet(0)

	theSet.Add("alpha")
	theSet.Add("beta")
	theSet.Add("gamma")
	theSet.Add("delta")
	theSet.Add("epsilon")
	theSet.Add("pi")
	theSet.Add("tau")
	theSet.Add("zeta")
	theSet.Add("theta")

	assert.Equal(t, theSet.Contains("alpha"), true, "Set should contain something that was added.")
	assert.Equal(t, theSet.Contains("beta"), true, "Set should contain something that was added.")
	assert.Equal(t, theSet.Contains("gamma"), true, "Set should contain something that was added.")
	assert.Equal(t, theSet.Contains("delta"), true, "Set should contain something that was added.")
	assert.Equal(t, theSet.Contains("epsilon"), true, "Set should contain something that was added.")
}

func TestSetMultipleNoAddContains(t *testing.T) {
	theSet := CreateTagSet(0)

	theSet.Add("alpha")
	theSet.Add("beta")
	theSet.Add("gamma")
	theSet.Add("delta")
	theSet.Add("epsilon")
	theSet.Add("pi")
	theSet.Add("tau")
	theSet.Add("zeta")
	theSet.Add("theta")

	assert.Equal(t, theSet.Contains("alpha2"), false, "Set should not contain something that was not added.")
	assert.Equal(t, theSet.Contains("beta2"), false, "Set should not contain something that was not added.")
	assert.Equal(t, theSet.Contains("gamma2"), false, "Set should not contain something that was not added.")
	assert.Equal(t, theSet.Contains("delta2"), false, "Set should not contain something that was not added.")
	assert.Equal(t, theSet.Contains("epsilon2"), false, "Set should not contain something that was not added.")
}

func TestSetClear(t *testing.T) {
	theSet := CreateTagSet(0)

	theSet.Add("alpha")
	theSet.Add("beta")
	theSet.Add("gamma")
	theSet.Add("delta")
	theSet.Add("epsilon")
	theSet.Add("pi")
	theSet.Add("tau")
	theSet.Add("zeta")
	theSet.Add("theta")

	theSet.Clear()

	theSet.Add("psi")

	assert.Equal(t, theSet.Contains("alpha"), false, "Set should not contain cleared items.")
	assert.Equal(t, theSet.Contains("beta"), false, "Set should not contain cleared items.")
	assert.Equal(t, theSet.Contains("gamma"), false, "Set should not contain cleared items")
	assert.Equal(t, theSet.Contains("delta"), false, "Set should not contain cleared items.")
	assert.Equal(t, theSet.Contains("epsilon"), false, "Set should not contain cleared items.")
	assert.Equal(t, theSet.Contains("psi"), true, "Set should contain something that was added.")
}

func TestSetSize(t *testing.T) {
	theSet := CreateTagSet(0)

	theSet.Add("alpha")
	assert.Equal(t, theSet.Size(), 1, "Set size should match items added.")
	theSet.Add("beta")
	assert.Equal(t, theSet.Size(), 2, "Set size should match items added.")
	theSet.Add("gamma")
	assert.Equal(t, theSet.Size(), 3, "Set size should match items added.")
	theSet.Add("delta")
	assert.Equal(t, theSet.Size(), 4, "Set size should match items added.")
	theSet.Add("epsilon")
	assert.Equal(t, theSet.Size(), 5, "Set size should match items added.")
}

func BenchmarkSetMapLookup(b *testing.B) {
	theMap := make(map[string]string, 0)
	theMap["alpha"] = "a"
	for n := 0; n < b.N; n++ {
		_, _ = theMap["alpha"]
	}
}

func BenchmarkSetMapFailedLookup(b *testing.B) {
	theMap := make(map[string]string, 0)
	theMap["beta"] = "b"
	for n := 0; n < b.N; n++ {
		_, _ = theMap["a"]
	}
}

func BenchmarkSetLookup(b *testing.B) {
	theSet := CreateTagSet(0)
	theSet.Add("alpha")
	for n := 0; n < b.N; n++ {
		_ = theSet.Contains("alpha")
	}
}

func BenchmarkSetFailedLookup(b *testing.B) {
	theSet := CreateTagSet(0)
	theSet.Add("beta")
	for n := 0; n < b.N; n++ {
		_ = theSet.Contains("alpha")
	}
}
