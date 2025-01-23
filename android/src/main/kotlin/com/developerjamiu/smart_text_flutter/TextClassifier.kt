package com.developerjamiu.smart_text_flutter

import android.annotation.TargetApi
import android.os.Build
import android.text.SpannableStringBuilder
import android.text.style.URLSpan
import android.text.util.Linkify
import android.view.textclassifier.TextClassifier
import android.view.textclassifier.TextLinks
import android.view.textclassifier.TextSelection

interface TextClassifer {
    fun detectLinksWithTextClassifier(text: String?, classifier: TextClassifier): List<ItemSpan>

    fun detectLinksWithLinkify(text: String?): List<ItemSpan>
}

class AndroidTextClassifer : TextClassifer {

    @TargetApi(Build.VERSION_CODES.P)
    override fun detectLinksWithTextClassifier(
        text: String?,
        classifier: TextClassifier
    ): List<ItemSpan> {
        if (text == null) return listOf();

        val classifiedText = classifier.generateLinks(buildGenerateLinksRequest(text));

        val linkResult = classifiedText.links.map { textLink ->
            LinkResult(
                textLink.start,
                textLink.end,
                textLink.getEntity(0),
            )
        }.toList()

        return generateSmartTextItemsFromLinks(text, linkResult);
    }

    @TargetApi(Build.VERSION_CODES.P)
    private fun buildGenerateLinksRequest(text: String): TextLinks.Request {
        return TextLinks.Request.Builder(text).build()
    }

    // For devices with SDk less than 30
    override fun detectLinksWithLinkify(text: String?): List<ItemSpan> {
        if (text == null) return listOf();

        val spannableStringBuilder = SpannableStringBuilder(text)
        Linkify.addLinks(
            spannableStringBuilder,
            Linkify.EMAIL_ADDRESSES + Linkify.PHONE_NUMBERS + Linkify.WEB_URLS
        )

        val spans = spannableStringBuilder.getSpans(0, text.length, URLSpan::class.java)

        val linkResult = spans.map { span ->
            LinkResult(
                spannableStringBuilder.getSpanStart(span),
                spannableStringBuilder.getSpanEnd(span),
                getLinkType(span.url)
            )
        }.toList()

        return generateSmartTextItemsFromLinks(text, linkResult);
    }

    private fun getLinkType(link: String): String {
        return when {
            link.startsWith("mailto") -> "email"
            link.startsWith("tel") -> "phone"
            else -> "url"
        }
    }

    private fun generateSmartTextItemsFromLinks(
        text: String,
        links: List<LinkResult>
    ): List<ItemSpan> {
        val resultList = mutableListOf<ItemSpan>()

        if (links.isEmpty()) return if (text.isNotEmpty()) listOf(
            ItemSpan(
                text,
                "text",
                text,
            )
        ) else listOf()

        var previousEnd = 0

        for (i in links.indices) {
            val currentLink = links[i]
            val textBefore = text.substring(previousEnd, currentLink.start)
            if (textBefore.isNotEmpty()) resultList.add(ItemSpan(textBefore, "text", textBefore))

            val currentText = text.substring(currentLink.start, currentLink.end)
            val linkSpan: ItemSpan = when (currentLink.type) {
                "address" -> ItemSpan(currentText, "address", currentText)
                "phone" -> {
                    val phone = if (currentText.startsWith("tel://")) {
                        currentText
                    } else {
                        "tel://$currentText"
                    }
                    ItemSpan(currentText, "phone", phone)
                }
                "email" -> {
                    val email = if (currentText.startsWith("mailto:")) {
                        currentText
                    } else {
                        "mailto:$currentText"
                    }
                    ItemSpan(currentText, "email", email)
                }
                "datetime" -> ItemSpan(
                    currentText,
                    "datetime",
                    currentText
                )
                "url" -> {
                    val url = if (currentText.startsWith("http://") || currentText.startsWith("https://")) {
                        currentText
                    } else {
                        "https://$currentText"
                    }
                    ItemSpan(currentText, "url", url)
                }
                else -> ItemSpan(currentText, "text", currentText)
            }

            resultList.add(linkSpan)
            previousEnd = currentLink.end
        }

        val textAfter = text.substring(links.last().end)
        if (textAfter.isNotEmpty()) resultList.add(ItemSpan(textAfter, "text", textAfter))

        return resultList
    }
}