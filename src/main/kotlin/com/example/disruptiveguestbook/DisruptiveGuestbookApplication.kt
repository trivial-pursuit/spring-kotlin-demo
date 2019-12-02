package com.example.disruptiveguestbook

import io.micronaut.runtime.Micronaut

object DisruptiveGuestbookApplication {

    @JvmStatic
    fun main(args: Array<String>) {
        Micronaut.build()
            .packages("com.example.disruptiveguestbook")
            .mainClass(DisruptiveGuestbookApplication.javaClass)
            .start()
    }
}