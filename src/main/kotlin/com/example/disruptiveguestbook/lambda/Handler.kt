package com.example.disruptiveguestbook.lambda

import com.amazonaws.serverless.exceptions.ContainerInitializationException
import com.amazonaws.services.lambda.runtime.Context
import com.amazonaws.services.lambda.runtime.RequestStreamHandler
import io.micronaut.function.aws.proxy.MicronautLambdaContainerHandler
import java.io.InputStream
import java.io.OutputStream

class Handler : RequestStreamHandler {

    override fun handleRequest(inputStream: InputStream, outputStream: OutputStream, context: Context) {
        handler.proxyStream(inputStream, outputStream, context)
    }

    companion object {
        private var handler: MicronautLambdaContainerHandler

        init {
            try {
                handler = MicronautLambdaContainerHandler()
            } catch (e: ContainerInitializationException) {
                // if we fail here. We re-throw the exception to force another cold start
                e.printStackTrace()
                throw RuntimeException("Could not initialize Micronaut", e)
            }

        }
    }
}
