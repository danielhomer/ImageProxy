package main

import (
	"context"
	"bytes"
	"log"
	"io"
	"github.com/discordapp/lilliput"
	"github.com/aws/aws-sdk-go/service/s3"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/aws"
	"gopkg.in/h2non/bimg.v1"
	"fmt"
	"os"
)


type Request struct {
	Path string `json:"path"`
}

type Response struct {
	Success bool `json:"success"`
	BeforeSize int `json:"before_size"`
	AfterSize int `json:"after_size"`
}

func main() {
	//lambda.Start(HandleRequest)

	buffer, err := bimg.Read("image.jpg")
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
	}

	newImage, err := bimg.NewImage(buffer).Convert(bimg.WEBP)
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
	}

	if bimg.NewImage(newImage).Type() == "webp" {
		fmt.Fprintln(os.Stderr, "The image was converted into webp")
	}
}

func HandleRequest(ctx context.Context, r Request) (Response, error) {
	log.Printf("Testing S3 connectivity. [Path: %s]", r.Path)

	sess := session.Must(session.NewSession())
	svc :=  s3.New(sess, aws.NewConfig().WithRegion("eu-west-1"))

	imgData, err := ReadImageFromS3(svc, r.Path)
	if err != nil {
		return Response{Success: false}, err
	}

	converted, err := ConvertToWebp(imgData)
	if err != nil {
		return Response{Success: false}, err
	}

	resp := Response{
		Success: true,
		BeforeSize: len(imgData),
		AfterSize: len(converted),
	}

	return resp, err
}

func ReadImageFromS3(svc *s3.S3, path string) ([]byte, error) {
	obj, err := svc.GetObject(&s3.GetObjectInput{
		Bucket: aws.String("dhomer-imageproxy"),
		Key:    aws.String(path),
	})
	if err != nil {
		return nil, err
	}

	defer obj.Body.Close()

	buf := bytes.NewBuffer(nil)

	if _, err := io.Copy(buf, obj.Body); err != nil {
		return nil, err
	}

	return buf.Bytes(), nil
}

func ConvertToWebp(inputBuf []byte) ([]byte, error) {
	decoder, err := lilliput.NewDecoder(inputBuf)
	if err != nil {
		return nil, err
	}
	defer decoder.Close()

	// get ready to resize image,
	// using 8192x8192 maximum resize buffer size
	ops := lilliput.NewImageOps(3840)
	defer ops.Close()

	// create a buffer to store the output image, 50MB in this case
	outputImg := make([]byte, 10*1024*1024)
	opts := &lilliput.ImageOptions{
		FileType:      ".webp",
		EncodeOptions: map[int]int{lilliput.WebpQuality: 85},
	}

	// resize and transcode image
	outputImg, err = ops.Transform(decoder, opts, outputImg)
	if err != nil {
		return nil, err
	}

	return outputImg, nil
}