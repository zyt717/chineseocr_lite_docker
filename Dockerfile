FROM pytorch/pytorch

WORKDIR /chineseocr_lite

RUN apt-get update && \
	apt-get install -y libsm6 libxrender1 libxext-dev libglib2.0-0 && \
	git clone https://github.com/ouyanghuiyu/chineseocr_lite.git /chineseocr_lite/ && \
	cd /chineseocr_lite/psenet/pse && \
	rm -rf pse.so  && \
	make && \
	cd /chineseocr_lite && \
	pip install -r requirements.txt && \
	sed -i 's/yield next(seq)/try:\n            yield next(seq)\n        except StopIteration:\n            return/g' /usr/local/lib/python3.8/site-packages/web/utils.py && \
	sed -i '/self.start_response = start_response/a\        self.directory = os.getcwd()' /opt/conda/lib/python3.7/site-packages/web/httpserver.py

EXPOSE 8080
ENTRYPOINT ["python","app.py","8080"]
