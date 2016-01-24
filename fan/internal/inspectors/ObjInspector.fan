using afBeanUtils

@NoDoc	// Advanced use only!
const class ObjInspector : JsonTypeInspector {

	const JsonConverter converter	:= ObjConverter()
	
	new make(|This|? in := null) { in?.call(this) }
	
	override JsonTypeMeta? inspect(Type objType, JsonTypeInspectors inspectors) {
		map := Field:JsonTypeMeta[:] { it.ordered=true }

		objType.fields.findAll { it.hasFacet(JsonProperty#) }.each |field| {
			prop := (JsonProperty) field.facet(JsonProperty#)
			if (prop.implType != null && prop.implType.fits(field.type).not)
				throw Err(ErrMsgs.objInspect_implTypeDoesNotFit(prop.implType, field))

			type := prop.implType ?: field.type
			
			if (prop.converterType != null) {
				map[field] = JsonTypeMeta {
					it.type		 		= type
					it.field	 		= field
					it.implType	 		= prop.implType 	?: field.type
					it.propertyName		= prop.propertyName	?: field.name
					it.storeNullValues	= prop.storeNullValues
					it.converter 		= createConverter(prop.converterType)
				}
			} else {			
				meta := inspectors.getOrInspect(type)
				map[field] = JsonTypeMeta {
					it.type		 		= type
					it.field	 		= field
					it.implType	 		= prop.implType 	?: field.type
					it.propertyName		= prop.propertyName	?: field.name
					it.storeNullValues	= prop.storeNullValues
					it.converter 		= meta.converter
					it.properties 		= meta.properties
					it.stash			= meta.stash
				}
			}
		}

		return JsonTypeMeta {
			it.type		 	= objType
			it.converter 	= this.converter
			it.properties 	= map
		}
	}
	
	** Creates a 'JsonConverter' instance using [BeanFactory]`afBeanUtils::BeanFactory`.
	** Called when '@Property.converterType' is not null.
	** 
	** Override if you prefer your converters to be autobuilt by IoC.
	virtual Obj? createConverter(Type type) {
		BeanFactory(type).create
	}
}
