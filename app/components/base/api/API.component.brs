function makeGetRequest(url as string, headers as object) as string
    urlTransfer = createURLTransfer("GET", url, headers)
    port = createObject("roMessagePort")
    urlTransfer.setMessagePort(port)

    if urlTransfer <> invalid and urlTransfer.asyncGetToString() then
        msg = wait(0, port)
        if type(msg) = "roUrlEvent" then
            code = msg.getResponseCode()
            body = msg.getString()

            if code < 200 or code >= 300 then
                handleHttpError(code, body)
            end if

            return body
        end if
    end if
end function

function makePostRequest(url as string, headers as object, requestBody as string) as string
    urlTransfer = createURLTransfer("POST", url, headers)
    port = createObject("roMessagePort")
    urlTransfer.setMessagePort(port)

    if urlTransfer <> invalid and urlTransfer.asyncPostFromString(requestBody) then
        msg = wait(0, port)
        if type(msg) = "roUrlEvent" then
            code = msg.getResponseCode()
            responseBody = msg.getString()

            if code < 200 or code >= 300 then
                handleHttpError(code, responseBody)
            end if

            return responseBody
        end if
    end if
end function

function createURLTransfer(method as string, url as string, headers as object) as object
    urlTransfer = createObject("roUrlTransfer")

    urlTransfer.setRequest(method)
    urlTransfer.setUrl(url)
    urlTransfer.setHeaders(headers)

    urlTransfer.setCertificatesFile("common:/certs/ca-bundle.crt")
    urlTransfer.initClientCertificates()

    urlTransfer.RetainBodyOnError(true)

    return urlTransfer
end function

sub handleHttpError(code as integer, body as string)
    if code >= 400 and code < 500 then
        m.top.response = {
            error: "client"
            code: code
            body: body
        }

    else if code >= 500 and code < 600 then
        m.top.response = {
            error: "server"
            code: code
            body: body
        }
    else
        m.top.response = {
            error: "unhandled"
            code: code
            body: body
        }
    end if
end sub
