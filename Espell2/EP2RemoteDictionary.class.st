Class {
	#name : #EP2RemoteDictionary,
	#superclass : #EP2RemoteObject,
	#category : #'Espell2-Kernel'
}

{ #category : #'accessing-specialInstVars' }
EP2RemoteDictionary >> array [
	^ self instanceVariableAtIndex: self dictionaryArrayIndex
]

{ #category : #'accessing-specialInstVars' }
EP2RemoteDictionary >> at: key [
	self flag: 'temporary value'. 
	^ nil
]

{ #category : #'accessing-specialInstVars' }
EP2RemoteDictionary >> at: key put: value [
	^ self 
		evaluateCode: 'aDictionary at: key put: value' 
		withTemps: 
			{ #aDictionary -> self.
			  #key -> key.
			  #value -> value}
]

{ #category : #'instVars-mapping' }
EP2RemoteDictionary >> dictionaryArrayIndex [ 
	^ (self systemDefinition instanceVariableMapping dictionaryArrayIndex) ifNil: [ self error: 'undefined index for array inst var in Dictionary' ]
]

{ #category : #'instVars-mapping' }
EP2RemoteDictionary >> dictionaryTallyIndex [ 
	^ (self systemDefinition instanceVariableMapping dictionaryTallyIndex) ifNil: [ self error: 'undefined index for tally inst var in Dictionary' ]
]

{ #category : #'gt-inspector' }
EP2RemoteDictionary >> gtInspectorIn: composite [
	<gtInspectorPresentationOrder: 1>
	^ composite table
		title: self asString;
		display: [ (self array allVariables 
				reject: [ :item | item isNilObject ]) ];
		column: 'Key' evaluated: [:assoc | assoc key ];
		column: 'Value' evaluated: [ :assoc | assoc value ];
		send: [ :assoc | assoc value ]
]

{ #category : #printing }
EP2RemoteDictionary >> printOn: aStream [
	aStream nextPutAll: '*a ';
		nextPutAll: self basicClass classNameFromAnyOrigin, ' [';
		nextPutAll: self tally asString;
		nextPutAll:' items]*'
]

{ #category : #'accessing-specialInstVars' }
EP2RemoteDictionary >> scanFor: anObject [
	"Scan the key array for the first slot containing either a nil (indicating an empty slot) or an element that matches anObject. Answer the index of that slot or zero if no slot is found. This method will be overridden in various subclasses that have different interpretations for matching elements."
	| element start finish |
	finish := self array size.
	start := 1.

	"Search in the array"
	start to: finish do:
		[:index | ((element := self array at: index) == self objectSpace nilObject 
			or: [element key = anObject])
			ifTrue: [^ index ]].

	^ 0  "No match"
]

{ #category : #'accessing-instVars' }
EP2RemoteDictionary >> tally [
	^ self instanceVariableAtIndex: self dictionaryTallyIndex
]
