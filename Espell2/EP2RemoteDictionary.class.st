Class {
	#name : #EP2RemoteDictionary,
	#superclass : #EP2RemoteObject,
	#category : #'Espell2-Kernel'
}

{ #category : #'accessing-specialInstVars' }
EP2RemoteDictionary >> array [
	^ self instanceVariableAtIndex: self dictionaryArrayIndex
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

{ #category : #'accessing-instVars' }
EP2RemoteDictionary >> tally [
	^ self instanceVariableAtIndex: self dictionaryTallyIndex
]
