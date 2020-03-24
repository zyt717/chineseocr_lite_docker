FROM pytorch/pytorch

WORKDIR /chineseocr_lite

RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
	sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list&& \
	mkdir ~/.pip && \
	echo "[global]" > ~/.pip/pip.conf && \
	echo "index-url = https://pypi.tuna.tsinghua.edu.cn/simple" >> ~/.pip/pip.conf 


RUN apt-get update && \
	apt-get install -y libsm6 libxrender1 libxext-dev libglib2.0-0 && \
	git clone https://github.com/ouyanghuiyu/chineseocr_lite.git /chineseocr_lite/ && \
	cd /chineseocr_lite/psenet/pse && \
	rm -rf pse.so  && \
	make && \
	cd /chineseocr_lite && \
	pip install -r requirements.txt && \
	sed -i 's/yield next(seq)/try:\n                yield next(seq)\n            except StopIteration:\n                return/g' /opt/conda/lib/python3.7/site-packages/web/utils.py && \
	sed -i '/self.start_response = start_response/a\        self.directory = os.getcwd()' /opt/conda/lib/python3.7/site-packages/web/httpserver.py

EXPOSE 8080
ENTRYPOINT ["python","app.py","8080"]
