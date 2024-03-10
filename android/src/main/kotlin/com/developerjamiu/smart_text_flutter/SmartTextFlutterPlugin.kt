package com.developerjamiu.smart_text_flutter

import android.app.Activity
import android.content.Context
import android.view.textclassifier.TextClassificationManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.*
import kotlinx.coroutines.Dispatchers

class SmartTextFlutterPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private val mainScope = CoroutineScope(Dispatchers.Main)
    private lateinit var textClassificationManager: TextClassificationManager

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "smart_text_flutter")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "classifyText") {
            val argument = call.arguments() as String?
            var itemSpans = listOf<ItemSpan>();
            mainScope.launch {
                try {
                    withContext(Dispatchers.Default) {
                        itemSpans = classifyText(argument)
                    }
                    result.success(itemSpans.map { it.toMap() })
                } catch (e: Throwable) {
                    result.success(itemSpans)
                }
            }

        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity as FlutterActivity
        initClassificationManager()
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity as FlutterActivity
        initClassificationManager()
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    private fun initClassificationManager() {
        textClassificationManager =
            activity?.getSystemService(Context.TEXT_CLASSIFICATION_SERVICE) as TextClassificationManager;
    }

    private fun classifyText(text: String?): List<ItemSpan> {
        return AndroidTextClassifer(textClassificationManager).classifyText(text);
    }
}
