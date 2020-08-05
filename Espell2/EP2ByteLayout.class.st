Class {
	#name : #EP2ByteLayout,
	#superclass : #EP2BitsLayout,
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #'testing-types' }
EP2ByteLayout >> isByteLayout [

	^ true
]

{ #category : #accessing }
EP2ByteLayout >> layoutName [

	^ #ByteLayout
]
