Class {
	#name : #EP2RemoteMethodDictionary,
	#superclass : #EP2RemoteDictionary,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteMethodDictionary class >> layoutClass [
	^ EP2MethodDictionaryLayout 
]

{ #category : #constants }
EP2RemoteMethodDictionary class >> modelInstSpec [
	^ 3
]

{ #category : #constants }
EP2RemoteMethodDictionary class >> role [ 
	^ 'MethodDictionary'
]

{ #category : #'gt-inspector' }
EP2RemoteMethodDictionary >> gtInspectorIn: composite [
	^ composite table
		title: self asString;
		display: [ (self array allVariables 
				reject: [ :item | item isNilObject ]) ];
		column: 'Key' evaluated: [:method | method asString ];
		send: [ :assoc | assoc value asRemoteCompiledMethod ]
]
