package com.developerjamiu.smart_text_flutter

data class LinkResult(val start: Int, val end: Int, val type: String)

data class ItemSpan(val text: String, val type: String, val rawValue: String) {
    fun toMap(): Map<String, Any> {
        return mapOf(
            "text" to text,
            "type" to type,
            "rawValue" to rawValue,
        )
    }
}