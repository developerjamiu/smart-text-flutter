package com.developerjamiu.smart_text_flutter

import android.view.textclassifier.TextClassificationManager
import android.view.textclassifier.TextLinks
import android.view.textclassifier.TextLinks.TextLink

interface TextClassifer {
    fun classifyText(text: String?): List<ItemSpan>
}

class AndroidTextClassifer(val textClassificationManager: TextClassificationManager) :
    TextClassifer {

    override fun classifyText(text: String?): List<ItemSpan> {
        val result = mutableListOf<ItemSpan>()

        if (text == null) return result;

        val textClassifier = textClassificationManager.textClassifier
        val classifiedText = textClassifier.generateLinks(buildGenerateLinksRequest(text));

        return generateSmartTextItemsFromLinks(text, classifiedText.links as List<TextLink>);
    }

    private fun buildGenerateLinksRequest(text: String): TextLinks.Request {
        return TextLinks.Request.Builder(text).build()
    }

    private fun generateSmartTextItemsFromLinks(
        text: String,
        links: List<TextLink>
    ): List<ItemSpan> {
        val resultList = mutableListOf<ItemSpan>()

        if (links.isEmpty()) return if (text.isNotEmpty()) listOf(
            ItemSpan(
                text,
                "text"
            )
        ) else listOf()

        var previousEnd = 0

        for (i in links.indices) {
            val currentLink = links[i]
            val textBefore = text.substring(previousEnd, currentLink.start)
            if (textBefore.isNotEmpty()) resultList.add(ItemSpan(textBefore, "text"))

            val linkSpan: ItemSpan = when (currentLink.getEntity(0)) {
                "address" -> ItemSpan(text.substring(currentLink.start, currentLink.end), "address")
                "phone" -> ItemSpan(text.substring(currentLink.start, currentLink.end), "phone")
                "email" -> ItemSpan(text.substring(currentLink.start, currentLink.end), "email")
                "datetime" -> ItemSpan(
                    text.substring(currentLink.start, currentLink.end),
                    "datetime"
                )
                "url" -> ItemSpan(text.substring(currentLink.start, currentLink.end), "url")
                else -> ItemSpan(text.substring(currentLink.start, currentLink.end), "text")
            }

            resultList.add(linkSpan)
            previousEnd = currentLink.end
        }

        val textAfter = text.substring(links.last().end)
        if (textAfter.isNotEmpty()) resultList.add(ItemSpan(textAfter, "text"))

        return resultList
    }
}

data class ItemSpan(val text: String, val type: String) {
    fun toMap(): Map<String, Any> {
        return mapOf(
            "text" to text,
            "type" to type
        )
    }
}