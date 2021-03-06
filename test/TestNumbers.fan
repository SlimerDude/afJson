
@Js
internal class TestNumbers : Test {
	
	Void testDocs() {
		obj := JsonConverters().fromJson("""{"num1":69, "num2":69, "num3":69}""", T_User4#) as T_User4
		verifyEq(obj.num1, 69)
		verifyEq(obj.num2, 69f)
		verifyEq(obj.num3, 69d)
		
		obj = JsonConverters().fromJson("""{"num1":69.0, "num2":69.0, "num3":69.0}""", T_User4#) as T_User4
		verifyEq(obj.num1, 69)
		verifyEq(obj.num2, 69f)
		verifyEq(obj.num3, 69d)

		obj = JsonConverters().fromJson("""{"num1":69.5, "num2":69.5, "num3":69.5}""", T_User4#) as T_User4
		verifyEq(obj.num1, 69)
		verifyEq(obj.num2, 69.5f)
		verifyEq(obj.num3, 69.5d)
	}
}

@Js
internal class T_User4 {
	@JsonProperty Int?		num1
	@JsonProperty Float?	num2
	@JsonProperty Decimal?	num3
}
