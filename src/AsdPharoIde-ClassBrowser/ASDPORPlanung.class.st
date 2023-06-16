Class {
	#name : #ASDPORPlanung,
	#superclass : #Object,
	#instVars : [
		'users',
		'loggedUsers'
	],
	#classVars : [
		'WriteMutex'
	],
	#classInstVars : [
		'uniqueInstancePlanung'
	],
	#category : #'AsdPharoIde-ClassBrowser-Utils'
}

{ #category : #voyage }
ASDPORPlanung class >> createAdmin [
	(ASDSUser benutzerName: 'admin' password: 'pwd' admin: true) save
]

{ #category : #'class initialization' }
ASDPORPlanung class >> current [
	^ uniqueInstancePlanung ifNil: [ uniqueInstancePlanung := self new ]
]

{ #category : #'default values' }
ASDPORPlanung class >> defaultAdminPassword [
   ^ 'topsecret'
]

{ #category : #'data sample' }
ASDPORPlanung class >> importDemoData [
| srs objects |
	srs := SixxReadStream readOnlyFileNamed: 'export.sixx'.
	objects := OrderedCollection new.
	[ srs atEnd ] whileFalse: [ objects add: srs next ].
	srs close.
	objects inspect
]

{ #category : #'class initialization' }
ASDPORPlanung class >> initialize [
	self reset
]

{ #category : #voyage }
ASDPORPlanung class >> initializeLocalhostMongoDB [
	| repository |
	repository := VOMongoRepository database: 'shs'.
	repository enableSingleton
]

{ #category : #'class initialization' }
ASDPORPlanung class >> initializeVoyageOnMemoryDB [
VOMemoryRepository new enableSingleton
]

{ #category : #voyage }
ASDPORPlanung class >> isVoyageRoot [
   "Indicates that instances of this class are top level documents
    in noSQL databases"
   ^ true
]

{ #category : #'class initialization' }
ASDPORPlanung class >> reset [
	uniqueInstancePlanung := nil.
	VORepository current reset.
	self initializeLocalhostMongoDB
]

{ #category : #'default values' }
ASDPORPlanung class >> version [
^'1.0.0'
]

{ #category : #operations }
ASDPORPlanung >> addLoggedUser: aUser [
	
	loggedUsers add: aUser
]

{ #category : #operations }
ASDPORPlanung >> allDevices [
	^ ASDSDevice selectAll
]

{ #category : #operations }
ASDPORPlanung >> allMultiMediaServerDevices [
	^ ASDSServerDeviceMultiMedia selectAll
]

{ #category : #operations }
ASDPORPlanung >> allMusicBoxServerDevices [
	^ ASDSServerDeviceMusicBox selectAll
]

{ #category : #operations }
ASDPORPlanung >> allUsers [
	^ ASDSUser selectAll
]

{ #category : #operations }
ASDPORPlanung >> allWebCamServerDevices [
	^ ASDSServerDeviceWebCam selectAll
]

{ #category : #initialization }
ASDPORPlanung >> initialize [
	super initialize.
	
]

{ #category : #accessing }
ASDPORPlanung >> loggedUsers [
	
	^ loggedUsers ifNil: [ loggedUsers := OrderedCollection new ]
]

{ #category : #accessing }
ASDPORPlanung >> loggedUsers: anObject [
	loggedUsers := anObject
]

{ #category : #operations }
ASDPORPlanung >> storeObject: anObject [
	anObject save
]

{ #category : #operations }
ASDPORPlanung >> storeUser: aUser [
	aUser save.
]

{ #category : #operations }
ASDPORPlanung >> userFromLogin: aLogin andPassword: aPassword [
	^ ASDSUser
		selectOne: [ :each | each benutzerName = aLogin & (each password = aPassword) ]
]

{ #category : #accessing }
ASDPORPlanung >> users [
	^ users ifNil: [ users := OrderedCollection new ]
]

{ #category : #accessing }
ASDPORPlanung >> users: anObject [
	users := anObject
]
