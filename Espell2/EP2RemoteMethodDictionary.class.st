Class {
	#name : #EP2RemoteMethodDictionary,
	#superclass : #EP2RemoteDictionary,
	#category : #'Espell2-Kernel'
}

{ #category : #'gt-inspector' }
EP2RemoteMethodDictionary >> gtInspectorIn: composite [
	<gtInspectorPresentationOrder: 1>
	^ composite table
		title: self asString;
		display: [ (self array allVariables 
				reject: [ :item | item isNilObject ]) ];
		column: 'Key' evaluated: [:method | method asString ];
		send: [ :assoc | assoc value ]
]
