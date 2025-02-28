Class {
	#name : #ASDPORPageCrudGenerator,
	#superclass : #ASDPORComponent,
	#category : #'AsdPharoIde-Core-Core'
}

{ #category : #testing }
ASDPORPageCrudGenerator class >> isAbstract [
	^ self = ASDPORPageModules
]

{ #category : #accessing }
ASDPORPageCrudGenerator class >> pageName [
	"Title of the page that will be used in menus and URLs."

	^ self subclassResponsibility
]

{ #category : #accessing }
ASDPORPageCrudGenerator class >> pagesToDisplay [
	^ (self allSubclasses reject: #isAbstract) sorted: #priority ascending
]

{ #category : #accessing }
ASDPORPageCrudGenerator class >> pathName [
	"Use to define the URL name"

	^ self pageName copyWithout: $  
]

{ #category : #accessing }
ASDPORPageCrudGenerator class >> priority [
	^ self subclassResponsibility
]

{ #category : #accessing }
ASDPORPageCrudGenerator >> pathName [
	^ self class pathName
]
