Class {
	#name : #ASDPORModelRefacturing,
	#superclass : #ASDPORModel,
	#instVars : [
		'selClass',
		'model'
	],
	#category : #'AsdPharoIde-ClassBrowser-Model'
}

{ #category : #'instance creation' }
ASDPORModelRefacturing class >> className: aName [
	^ self new 
	selClass: aName;
	yourself
]

{ #category : #'instance creation' }
ASDPORModelRefacturing class >> selClass: aName [
	^ self new
		selClass: aName;
		yourself
]

{ #category : #'initialize - release' }
ASDPORModelRefacturing >> initialize [
	super initialize.
	model := RBNamespace onEnvironment: RBBrowserEnvironment new.
]

{ #category : #accessing }
ASDPORModelRefacturing >> model [
	^ model
]

{ #category : #accessing }
ASDPORModelRefacturing >> selClass [
	^ selClass
]

{ #category : #accessing }
ASDPORModelRefacturing >> selClass: anObject [
	selClass := anObject
]
