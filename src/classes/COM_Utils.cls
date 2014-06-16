/*

@author: 		Sukrut Wagh
@description:	Utility providing boiler plate methods

*/

global class COM_Utils {
	
	global static final String EMPTY = '';

	/**
	 * Supported types: String, List
	 * Note: Set<String> is not recognized as an instanceof Set<object> and 
	 * 		 Map<String,String> is not recognized as an instanceof Map<Object,Object>
	 * @param obj
	 * @return
	 */
	global static Boolean isNotEmpty(final Object obj) {
		if(null != obj) {
			if(obj instanceof String) {
				return String.isBlank((String)obj) ? false : true;
			} else if(obj instanceof List<Object>) {
				return (((List<Object>)obj).isEmpty()) ? false : true;
			} /*else if(obj instanceof Set<Object>) {
				return (((Set<Object>)obj).isEmpty()) ? false : true;
			} else if(obj instanceof Map<Object,Object>) {
				return (((Map<Object,Object>)obj).isEmpty()) ? false : true;
			}*/
			return true;
		}
		return false;
	}
	
	global static Boolean isEmpty(final Object obj) {
		return !isNotEmpty(obj);
	}
	
	/*
	* Converts the list to a String. Values are separated by the separator character.
	* @param l			list of string
	* @param separator	separator character
	* @param wrapStr	optional. In case the value has to be wrappep/surronded by a string. 
	*					e.g: when wrapStr=quote & separator=comma, returned string will be in format 'val 1','val 2'
	*/
	global static String toString(final List<String> l, final String separator, String wrapStr) {
		String resp = '';
		if(COM_Utils.isEmpty(wrapStr)){
			wrapStr = '';
		}
		if(COM_Utils.isNotEmpty(l) && COM_Utils.isNotEmpty(separator)) {
			for(String val : l) {
				resp += wrapStr+val+wrapStr+separator;
			}
			if(resp.endsWith(separator)) {
				resp = resp.removeEndIgnoreCase(separator);
			}
		}
		return resp;
	}
	
	/*
		Copied from https://code.google.com/p/apex-lang/source/browse/tags/1.10/src/classes/StringUtils.cls
		http://commons.apache.org/proper/commons-lang/javadocs/api-release/index.html
		Gets the substring after the last occurrence of a separator. The separator is not returned.
		A null string input will return null. An empty ("") string input will return the empty string. 
		An empty or null separator will return the empty string if the input string is not null.
		
		If nothing is found, the empty string is returned.
		
		 StringUtils.substringAfterLast(null, *)      = null
		 StringUtils.substringAfterLast("", *)        = ""
		 StringUtils.substringAfterLast(*, "")        = ""
		 StringUtils.substringAfterLast(*, null)      = ""
		 StringUtils.substringAfterLast("abc", "a")   = "bc"
		 StringUtils.substringAfterLast("abcba", "b") = "a"
		 StringUtils.substringAfterLast("abc", "c")   = ""
		 StringUtils.substringAfterLast("a", "a")     = ""
		 StringUtils.substringAfterLast("a", "z")     = ""
			
	*/
	global static String substringAfterLast(final String str, final String separator) {
        if (isEmpty(str)) {
            return str;
        }
        if (isEmpty(separator)) {
            return EMPTY;
        }
        Integer pos = str.lastIndexOf(separator);
        if (pos == -1 || pos == (str.length() - separator.length())) {
            return EMPTY;
        }
        return str.substring(pos + separator.length());
    }
	
}