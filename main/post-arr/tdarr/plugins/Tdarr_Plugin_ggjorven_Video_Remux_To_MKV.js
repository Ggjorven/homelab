/*
 * Credits:
 *  - Tdarr_Plugin_MC93_Migz1Remux by MC93 (Migz): remux flow, genpts handling
 *    and container conformance logic
 *  - Tdarr_Plugin_00td_action_remux_container by HaveAGitGat: remux concept
 */

const details = () => ({
    id: 'Tdarr_Plugin_ggjorven_Video_Remux_To_MKV',
    Stage: 'Pre-processing',
    Name: 'ggjorven | Video | Remux Container To MKV',
    Type: 'Video',
    Operation: 'Transcode',
    Description: 'Remuxes any container to MKV without re-encoding. Streams that MKV cannot hold '
        + '(data, EIA-608, timed ID3) are dropped and mov_text subtitles are converted to SRT.\n\n',
    Version: '1.0',
    Tags: 'pre-processing,ffmpeg,video only',
    Inputs: [],
});

const TIMESTAMP_FIX_CONTAINERS = ['ts', 'avi', 'mpg', 'mpeg'];
const DROPPED_CODECS = ['eia_608', 'timed_id3', 'bin_data'];

const plugin = (file) => {
    const response = {
        processFile: false,
        preset: '',
        container: '.mkv',
        handBrakeMode: false,
        FFmpegMode: true,
        reQueueAfter: true,
        infoLog: '',
    };

    if (file.fileMedium !== 'video') {
        response.infoLog += 'File is not a video. \n';
        return response;
    }

    if (file.container === 'mkv') {
        response.infoLog += '☑File is already in the MKV container. \n';
        return response;
    }

    const outputArgs = [];
    let outputSubtitleIndex = 0;

    file.ffProbeData.streams.forEach((stream) => {
        const codec = String(stream.codec_name).toLowerCase();

        if (stream.codec_type === 'data' || DROPPED_CODECS.includes(codec)) {
            outputArgs.push(`-map -0:${stream.index}`);
            response.infoLog += `Dropping stream ${stream.index} (${codec}), not supported by MKV. \n`;
            return;
        }

        if (stream.codec_type === 'subtitle') {
            if (codec === 'mov_text') {
                outputArgs.push(`-c:s:${outputSubtitleIndex} srt`);
                response.infoLog += `Converting mov_text subtitle stream ${stream.index} to SRT. \n`;
            }
            outputSubtitleIndex += 1;
        }
    });

    const inputArgs = TIMESTAMP_FIX_CONTAINERS.includes(file.container.toLowerCase())
        ? '-fflags +genpts'
        : '';

    response.preset = `${inputArgs}, -map 0 -c copy ${outputArgs.join(' ')} -max_muxing_queue_size 9999`;
    response.processFile = true;
    response.infoLog += `File is ${file.container}, remuxing to MKV. \n`;
    return response;
};

module.exports.details = details;
module.exports.plugin = plugin;
