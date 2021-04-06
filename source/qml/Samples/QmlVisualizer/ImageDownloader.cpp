#include "ImageDownloader.h"

size_t ImageDownloader::callbackfunction(void* ptr, size_t size, size_t nmemb, void* userdata)
{
	FILE* stream = (FILE*)userdata;
	if (!stream)
	{
		printf("!!! No stream\n");
		return 0;
	}

	size_t written = fwrite((FILE*)ptr, size, nmemb, stream);
	return written;
}

char* ImageDownloader::Convert(const std::string& s) //Convert url from std::string to raw char pointer
{
	char* pc{ new char[s.size() + 1] };
	std::strcpy(pc, s.c_str());
	return pc;
}

timeval ImageDownloader::get_timeout(CURLM* multi_handle)
{
	long curl_timeo = -1;
	/* set a suitable timeout to play around with */
	struct timeval timeout;
	timeout.tv_sec = 1;
	timeout.tv_usec = 0;

	curl_multi_timeout(multi_handle, &curl_timeo);
	if (curl_timeo >= 0) {
		timeout.tv_sec = curl_timeo / 1000;
		if (timeout.tv_sec > 1)
			timeout.tv_sec = 1;
		else
			timeout.tv_usec = (curl_timeo % 1000) * 1000;
	}
	return timeout;
}

int ImageDownloader::wait_if_needed(CURLM* multi_handle, timeval& timeout)
{
	fd_set fdread;
	fd_set fdwrite;
	fd_set fdexcep;
	FD_ZERO(&fdread);
	FD_ZERO(&fdwrite);
	FD_ZERO(&fdexcep);
	int maxfd = -1;
	/* get file descriptors from the transfers */
	auto mc = curl_multi_fdset(multi_handle, &fdread, &fdwrite, &fdexcep, &maxfd);

	if (mc != CURLM_OK)
	{
		std::cerr << "curl_multi_fdset() failed, code " << mc << "." << std::endl;
	}
	/* On success the value of maxfd is guaranteed to be >= -1. We call
		   sleep for 100ms, which is the minimum suggested value in the
		   curl_multi_fdset() doc. */
	if (maxfd == -1)
	{
		std::this_thread::sleep_for(std::chrono::milliseconds(100));
	}

	int rc = maxfd != -1 ? select(maxfd + 1, &fdread, &fdwrite, &fdexcep, &timeout) : 0;
	return rc;
} 

bool ImageDownloader::download_jpeg(const std::string& imgName, char* url)
{
    const std::string imgSource = SolutionDir + imageFolder + imgName;
	FILE* fp = fopen(Convert(imgSource), "wb");
	if (!fp)
	{
		printf("!!! Failed to create file on the disk\n");
        return false;
	}

	CURLM* multi_handle;
	int still_running = 0;
	multi_handle = curl_multi_init();

	CURL* curlCtx = curl_easy_init();
	curl_easy_setopt(curlCtx, CURLOPT_URL, url);
	curl_easy_setopt(curlCtx, CURLOPT_WRITEDATA, fp);
	curl_easy_setopt(curlCtx, CURLOPT_WRITEFUNCTION, callbackfunction);
	curl_easy_setopt(curlCtx, CURLOPT_FOLLOWLOCATION, 1);

	curl_multi_add_handle(multi_handle, curlCtx);

	curl_multi_perform(multi_handle, &still_running);

	while (still_running)
	{
		struct timeval timeout = get_timeout(multi_handle);
		auto rc = wait_if_needed(multi_handle, timeout);
		if (rc >= 0)
		{
			/* timeout or readable/writable sockets */
			curl_multi_perform(multi_handle, &still_running);
		} 
	}
	
	curl_multi_cleanup(multi_handle);

	curl_easy_cleanup(curlCtx);

	fclose(fp);

    return true;
}

void ImageDownloader::clearImageFolder()
{
    const auto dir_path = SolutionDir + imageFolder;
    for (auto& path : fs::directory_iterator(dir_path)) {
        fs::remove_all(path);
    }
}
