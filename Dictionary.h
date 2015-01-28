/*
 * Dictionary.h
 *
 * This code was created by the Paradigm Research
 * Corporate Education Department
 * Copyright 1995, All Rights Reserved, Paradigm Research, Inc.
 */

/* All indices are from 0 */

/* Description format is cgi encoding: key=value&key2=&key3=value3\0 */

#ifndef DICTIONARY_H
#define DICTIONARY_H

#include <objc/Object.h>

#define DEF_CAPACITY 3
#define GROW_PERCENTAGE 0.75
#define GROWTH_RATE 2

@class String,Array,DictionaryIterator;

struct listnode{

	struct listnode *next;
	id key;
	id value;

};

@interface Dictionary:Object
{
	struct listnode **hashtable;
	int size;//use size -1 for % in hashing functions
	int used;

}

//Doesnt adopt the string
- initFromDescription:(String *)aString;

/* May alter to capacity to achieve a prime # */

- initWithCapacity: (unsigned)numItems;

- free;//doesnt free objects

- (unsigned) count;

- (BOOL) isKey:(String *)aKey;
- (BOOL) isStringKey:(const char *)aKey;

- objectForKey: (String*)aKey;
- objectForStringKey:(const char *)aKey;

//returns and orphans the old one if it exists, copies the key, adopts anObject
- setObject: anObject forKey: (String*)aKey;

- setObject:anObject forStringKey:(const char *)aKey;

- setStringValue:(const char *)aStr forStringKey:(const char *)aKey;
- setIntValue:(int)aVal forStringKey:(const char *)aKey;
- setFloatValue:(float)aVal forStringKey:(const char *)aKey;
- setDoubleValue:(double)aVal forStringKey:(const char *)aKey;

//returns obj & frees the keys, may be nil
- orphanObjectForKey: (String*)aKey;
- orphanObjectForStringKey:(const char *)aKey;

- (void) freeAllObjects;

//returns objects & frees the keys, caller should free the returned list, may be empty
- (Array *) orphanObjectsForKeys: (Array*)keyArray;

//Adopts the entries
- (void) addEntriesFromDictionary: (Dictionary*)otherDictionary;

- (BOOL) isEqual: (Dictionary*)otherDictionary;

//Currently only works if all of the objects are Strings *, caller should free
- (String*) description;

//Passes pointers to objects in Dictionary, DO NOT free them, DO free the array
- (Array*) allKeys;
- (Array*) allValues;

//should be freed by the caller
- (DictionaryIterator *) iterator;
@end

#endif



