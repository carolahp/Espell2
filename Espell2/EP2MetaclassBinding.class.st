Class {
	#name : #EP2MetaclassBinding,
	#superclass : #EP2LiteralBinding,
	#category : #'Espell2-Compiler-Bindings'
}

{ #category : #'from local to remote' }
EP2MetaclassBinding >> asRemoteObjectInObjectSpace: anObjectSpace [ 
	| theClass |
	"With these implementation each class side method will have its own class association.
	To save space we should cache them and share them"
	theClass := self classNamed: name asSymbol.
	^ anObjectSpace 
			newAssociationWithKey: anObjectSpace nilObject
			andValue: theClass classSide mirror.
]
