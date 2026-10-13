/*
 * Credits:
 *  - Tdarr_Plugin_MC93_MigzImageRemoval by MC93 (Migz): image codec detection
 *    and stream removal approach
 */

const details = () => ({
    id: 'Tdarr_Plugin_ggjorven_Video_Remove_Image_Streams',
    Stage: 'Pre-processing',
    Name: 'ggjorven | Video | Remove Cover Images And Image Streams',
    Type: 'Video',
    Operation: 'Transcode',
    Description: 'Removes attached pictures, MJPEG/PNG/GIF/BMP/TIFF streams and image attachments '
        + '(cover.jpg etc.). The plugin never removes the last real video stream.\n\n',
    Version: '1.0',
    Tags: 'pre-processing,ffmpeg,video only',
    Inputs: [],
});

const IMAGE_CODECS = ['mjpeg', 'png', 'gif', 'bmp', 'tiff'];

const isImageVideoStream = (stream) => stream.codec_type === 'video'
    && (stream.disposition?.attached_pic === 1 || IMAGE_CODECS.includes(stream.codec_name));

const isImageAttachment = (stream) => stream.codec_type === 'attachment'
    && (/^image\//i.test(stream.tags?.mimetype || '')
        || /\.(jpe?g|png|gif|bmp|webp)$/i.test(stream.tags?.filename || ''));

const plugin = (file) => {
    const response = {
        processFile: false,
        preset: '',
        container: `.${file.container}`,
        handBrakeMode: false,
        FFmpegMode: true,
        reQueueAfter: true,
        infoLog: '',
    };

    if (file.fileMedium !== 'video') {
        response.infoLog += 'File is not a video. \n';
        return response;
    }

    const { streams } = file.ffProbeData;
    const hasRealVideo = streams.some((stream) => stream.codec_type === 'video' && !isImageVideoStream(stream));

    if (!hasRealVideo) {
        response.infoLog += 'No real video stream found, skipping to avoid removing the only video. \n';
        return response;
    }

    const removals = streams.filter((stream) => isImageVideoStream(stream) || isImageAttachment(stream));

    if (removals.length === 0) {
        response.infoLog += '☑File has no image streams. \n';
        return response;
    }

    removals.forEach((stream) => {
        response.infoLog += `Removing image stream ${stream.index} (${stream.codec_name}). \n`;
    });

    const removalArgs = removals.map((stream) => `-map -0:${stream.index}`).join(' ');
    response.preset = `, -map 0 ${removalArgs} -c copy -max_muxing_queue_size 9999`;
    response.processFile = true;
    return response;
};

module.exports.details = details;
module.exports.plugin = plugin;
