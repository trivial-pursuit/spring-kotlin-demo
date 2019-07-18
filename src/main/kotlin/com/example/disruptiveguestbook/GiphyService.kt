package com.example.disruptiveguestbook

import com.fasterxml.jackson.annotation.JsonProperty
import io.micronaut.http.HttpRequest
import io.micronaut.http.client.RxHttpClient
import io.micronaut.http.client.annotation.Client
import io.micronaut.http.uri.UriTemplate
import javax.inject.Singleton

@Singleton
class GiphyService(
        @Client("\${giphy.url}") private val httpClient: RxHttpClient,
        private val giphyProperties: GiphyProperties
) {

    fun findUrlForTag(tag: String): String? {

        val uri = UriTemplate.of("/search?api_key={api-key}&q={tag}&limit={limit}&offset=0&rating=G&lang=en")
                .expand(mapOf(
                        "api-key" to giphyProperties.apikey,
                        "tag" to tag,
                        "limit" to 10))

        return httpClient
                .retrieve(
                        HttpRequest.GET<Any>(uri),
                        GiphyResponse::class.java)
                .firstElement()
                ?.blockingGet()
                ?.data
                ?.shuffled()
                ?.firstOrNull()
                ?.embedUrl
    }
}

data class GiphyResponse(val data: List<Giph>)

data class Giph(@JsonProperty("embed_url") val embedUrl: String)
