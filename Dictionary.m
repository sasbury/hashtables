
#include "Dictionary.h"
#include "libcgi.h"

/* Finds a prime number close to the given value */
int ceilPrime(int aValue)
{
	int retVal;
	
	retVal = aValue;
	
	if(aValue <= 5) retVal = 5;
	else if(aValue <= 7) retVal = 7;
	else if(aValue <= 13) retVal = 13;
	else if(aValue <= 17) retVal = 17;
	else if(aValue <= 51) retVal = 51;
	else if(aValue <= 71) retVal = 71;
	else if(aValue <= 125) retVal = 97;
	else if(aValue <= 275) retVal = 241;
	else if(aValue <= 425) retVal = 397;
	else if(aValue <= 525) retVal = 499;
	else if(aValue <= 800) retVal = 743;
	else if(aValue <= 1100) retVal = 997;
	else if(aValue <= 1750) retVal = 1499;
	else if(aValue <= 2250) retVal = 1999;
	else if(aValue <= 4250) retVal = 3989;
	else if(aValue <= 5500) retVal = 4999;
	else if(aValue <= 8000) retVal = 7499;
	else if(aValue <= 11000) retVal = 9973;
	else if((aValue % 2) == 0) retVal+=1;
	
	return retVal;
}

@implementation Dictionary

- initFromDescription:(String *)aString
{
  String * key = nil;
  id value = nil;
  Array *objects;
  
  self = [self initWithCapacity:DEF_CAPACITY];
  
  if((aString != nil)&&([aString isEmptyOrNULL] == NO))
    {
      
      objects = [self objectsFromString:aString];
      
      if(objects != nil)
	{
	  int i,max;
	  
	  max = [objects count];
	  
	  for(i=0;i<max;i++)
	    {
	      if(nil == key)
		{
		  key = [objects objectAt:i];
		}
	      else if(nil == value)
		{
		  value = [objects objectAt:i];
		  [self setObject:value forKey:key];
		  value = key = nil;
		}
	      
	    }
	  
	  if((nil != value)&&(nil != key))
	    {
	      [self setObject:value forKey:key];
	      value = key = nil;
	    }			
	  
	  objects = [objects free];
	}
    }
  return self;
}

- initWithCapacity: (unsigned)numItems
{
  int newS;
  
  self = [super init];
  
  newS = (numItems <= 0) ? DEF_CAPACITY:ceilPrime(numItems);
  
  hashtable = (struct listnode **) calloc(newS,sizeof(struct listnode *));
  size = newS;
  used = 0;
  
  return self;
}

- init
{
  return [self initWithCapacity:DEF_CAPACITY];
}

- free
{
  struct listnode *newNode = NULL;
  struct listnode *nextNode = NULL;
  int i;
  
  for(i = 0; i < size; i++)
    {
      
      newNode = hashtable[i];
      
      while(newNode != NULL)
	{
	  
	  nextNode = newNode->next;
	  free(newNode);
	  newNode = nextNode;
	  
	}
      
      hashtable[i] = 0;
      
    }
  
  if(hashtable != NULL) free(hashtable);
  
  return [super free];
}

- (unsigned) count
{
	return used;
}

- (BOOL) isKey:(String *)aKey
{
	return ([self objectForKey:aKey] == nil) ? NO : YES;
}

- (BOOL) isStringKey:(const char *)aKey
{
	return ([self objectForStringKey:aKey] == nil) ? NO : YES;
}

- objectForStringKey:(const char *)aKey
{
  String *tmp = nil;
  id retVal = nil;

  tmp = [[String alloc] initFromCString:aKey];
  retVal = [self objectForKey:tmp];
  tmp = [tmp free];

  return retVal;
}

- objectForKey: (String*)aKey
{
  id returnValue = nil;
  
  if((aKey != nil)&&(used > 0))
    {
      
      unsigned long index;
      struct listnode *node = NULL;
      
      index = [aKey hash] % (size -1);
      node = hashtable[index];
      
      if(node != NULL)
	{
	  do
	    {      
	      if((node->key != nil)
		 &&([aKey isEqual:node->key] == YES))
		{
		  returnValue = node->value;
		}
	      else
		{
		  node = node->next;
		}

	    }while((returnValue == nil)&&(node != NULL));
	}
    }
  return returnValue;
}

- setObject:anObject forStringKey:(const char *)aKey
{
  String *tmp = nil;
  id retVal = nil;

  tmp = [[String alloc] initFromCString:aKey];
  retVal = [self setObject:anObject forKey:tmp];
  tmp = [tmp free];

  return retVal;
}


- setStringValue:(const char *)aStr forStringKey:(const char *)aKey
{
  String *tmp = nil;
  String *tmp2 = nil;
  id retVal = nil;

  tmp = [[String alloc] initFromCString:aKey];
  tmp2 = [[String alloc] initFromCString:aStr];
  retVal = [self setObject:tmp2 forKey:tmp];
  if(tmp) tmp = [tmp free];

  return retVal;
}

- setIntValue:(int)aVal forStringKey:(const char *)aKey
{
  String *tmp = nil;
  String *tmp2 = nil;
  id retVal = nil;

  tmp = [[String alloc] initFromCString:aKey];
  tmp2 = [[String alloc] init];
  [tmp2 setIntValue:aVal];
  retVal = [self setObject:tmp2 forKey:tmp];
  if(tmp) tmp = [tmp free];

  return retVal;
}

- setFloatValue:(float)aVal forStringKey:(const char *)aKey
{
  String *tmp = nil;
  String *tmp2 = nil;
  id retVal = nil;

  tmp = [[String alloc] initFromCString:aKey];
  tmp2 = [[String alloc] init];
  [tmp2 setFloatValue:aVal];
  retVal = [self setObject:tmp2 forKey:tmp];
  if(tmp) tmp = [tmp free];

  return retVal;
}

- setDoubleValue:(double)aVal forStringKey:(const char *)aKey
{
  String *tmp = nil;
  String *tmp2 = nil;
  id retVal = nil;

  tmp = [[String alloc] initFromCString:aKey];
  tmp2 = [[String alloc] init];
  [tmp2 setDoubleValue:aVal];
  retVal = [self setObject:tmp2 forKey:tmp];
  if(tmp) tmp = [tmp free];

  return retVal;
}

- setObject: anObject forKey: (String *)aKey
{
  id valueToReturn = nil;
  
  if((aKey != nil) && (anObject != nil))
    {
      
      unsigned long index;
      struct listnode *node = NULL;
      
      index = [aKey hash] % (size -1);
      
      node = hashtable[index];
      
      if(node != NULL){
	
	do
	  {
	    
	    if((node->key != nil)&&([aKey isEqual:node->key] == YES))
	      {
		
		valueToReturn = node->value;//cache the old one and
		  
		  node->value = anObject;//replace it
		    
	      }
	    else
	      {
		
		node = node->next;
		
	      }
	    
	    
	  }while((valueToReturn == nil)&&(node != NULL));
	
      }
      
      if(valueToReturn == nil)
	{
	  
	  node = (struct listnode *) calloc(1,sizeof(struct listnode));
	  
	  node->key = [[String alloc] initFromString:aKey];
	  node->value = anObject;
	  node->next = hashtable[index];
	  
	  hashtable[index]= node;
	  
	  used++;
	  
	  //check if we need to grow
	    if(used >= (GROW_PERCENTAGE * size)){
	      
	      struct listnode **newTable;
	      int newS = GROWTH_RATE * size, newUsed = 0;
	      DictionaryIterator * iterator = [self iterator];
	      struct listnode *newNode = NULL;
	      struct listnode *nextNode = NULL;
	      unsigned long curIndex, i;
	      
	      newS = ceilPrime(newS);
	      
	      [iterator initState];
	      
	      newTable = (struct listnode **) calloc(newS,sizeof(struct listnode *));
	      
	      while([iterator nextState] == YES)
		{
		  
		  curIndex = [[iterator key] hash] % (newS -1);
		  
		  newNode = 
		    (struct listnode *) calloc(1,sizeof(struct listnode));
		  
		  newNode->key = [iterator key];
		  newNode->value = [iterator value];
		  newNode->next = newTable[curIndex];
		  newTable[curIndex]= newNode;
		  
		  newUsed++;
		}
	      /*
		 [iterator initState];
		 
		 while([iterator nextState] == YES)
		 {
		 [iterator removeCurrentValueSaveKey];
		 }
		 */
	      for(i = 0; i < size; i++)
		{
		  
		  newNode = hashtable[i];
		  
		  while(newNode != NULL)
		    {
		      
		      nextNode = newNode->next;
		      free(newNode);
		      newNode = nextNode;
					
		    }
		  
		  hashtable[i] = 0;
		  
		}
	      
	      free(hashtable);
	      
	      hashtable = newTable;
	      size = newS;
	      used = newUsed;
	      
	      iterator = [iterator free];
	      
	    }
	  
	}
      
    }
  
  return valueToReturn;
}


- orphanObjectForStringKey:(const char *)aKey
{
  String *tmp = nil;
  id retVal = nil;

  tmp = [[String alloc] initFromCString:aKey];
  retVal = [self orphanObjectForKey:tmp];
  tmp = [tmp free];

  return retVal;
}


- orphanObjectForKey: (String*)aKey
{

	id returnValue = nil;

	if(aKey != nil)
	{
	
		unsigned long index;
		struct listnode *node = NULL;
		struct listnode *prevNode = NULL;
		
		index = [aKey hash] % (size -1);
		node = hashtable[index];
		
		if(node != NULL)
		{
		
			if((node->key != nil)&&([aKey isEqual:node->key] == YES)){
			
				hashtable[index] = node->next;
				returnValue = node->value;
				
				[node->key free];
				node->key = nil;
				
				free(node);
				
				used --;
			
			}
			else
			{
		
				while((returnValue == nil)&&(node != NULL))
				{
				
					if((node->key != nil)&&([aKey isEqual:node->key] == YES))
					{
					
						prevNode->next = node->next;
						returnValue = node->value;
						
						[node->key free];
						node->key = nil;
						
						free(node);
						
						used --;
					
					}
					else
					{
					
						prevNode = node;
						node = node->next;
					
					}
				
				
				}
			
			}
		
		}
	
	}
	return returnValue;
}

- (void) freeAllObjects
{
	DictionaryIterator * iterator;
	
	iterator = [self iterator];
	
	[iterator initState];
				
	while([iterator nextState] == YES)
	{
		[iterator removeAndFreeCurrentValue];
	}
	
	used = 0;
	
	iterator = [iterator free];
}

- (Array *) orphanObjectsForKeys: (Array*)keyArray
{
	Array *returnValue;
	int i,max;
	
	max = [keyArray count];
	
	returnValue = [[Array alloc] initCount:max];
	
	for(i=0;i<max;i++)
	{
	
		[returnValue addObject:
			[self orphanObjectForKey:[keyArray objectAt:i]]];
	
	}
	
	return returnValue;
}

- (void) addEntriesFromDictionary: (Dictionary*)otherDictionary
{
	DictionaryIterator * iterator;
	String *key;
	
	iterator = [otherDictionary iterator];
	
	[iterator initState];
				
	while([iterator nextState] == YES)
	{
		key = [iterator key];
		[self setObject:[iterator value]
				forKey:key];
	}
	
	iterator = [iterator free];
}

- (BOOL) isEqual: (Dictionary*)otherDictionary
{
	DictionaryIterator * iterator;
	BOOL returnValue = NO;
	
	if([otherDictionary count] == [self count])
	{
		iterator = [otherDictionary iterator];
		
		[iterator initState];
					
		while([iterator nextState] == YES)
		{
			returnValue = ([self objectForKey:[iterator key]]==nil) ? NO : YES;
					
			if(returnValue == NO) break;
		}
		
		iterator = [iterator free];
	}
	return returnValue;
}

- (String*) description
{
	DictionaryIterator * iterator;
	String *returnValue;
	String * key;
	id value;
	
	returnValue = [[String alloc] init];
	
	iterator = [self iterator];
	
	[iterator initState];
				
	while([iterator nextState] == YES)
	{
		key = [iterator key];
		value = [iterator value];
		
		if((key != nil) && ([key isEmptyOrNULL] == NO))
		{
			[self appendObject:key toString:returnValue];
			[self appendObject:value toString:returnValue];
		
		}
	}
	
	iterator = [iterator free];
	
	return returnValue;
}

- (Array*) allKeys
{
	DictionaryIterator * iterator;
	Array *returnValue;
	
	returnValue = [[Array alloc] initCount:DEF_CAPACITY];
	
	iterator = [self iterator];
	
	[iterator initState];
				
	while([iterator nextState] == YES)
	{
		[returnValue addObject:[iterator key]];
	}
	
	iterator = [iterator free];
	return returnValue;
}

- (Array*) allValues
{
	DictionaryIterator * iterator;
	Array *returnValue;
	
	returnValue = [[Array alloc] initCount:DEF_CAPACITY];
	
	iterator = [self iterator];
	
	[iterator initState];
				
	while([iterator nextState] == YES)
	{
		[returnValue addObject:[iterator value]];
	}
	
	iterator = [iterator free];
	return returnValue;
}

- (DictionaryIterator *) iterator
{
	return [[DictionaryIterator alloc] initForDict:self table:hashtable size:size];
}

- (void) decrementUsed //private, used by iterator
{
	used--;
}
@end
