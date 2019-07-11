package com.example.disruptiveguestbook

import io.micronaut.context.annotation.ConfigurationProperties

@ConfigurationProperties("giphy")
class GiphyProperties {
    lateinit var apikey: String
    var url: String = "https://api.giphy.com/v1/gifs"
}
